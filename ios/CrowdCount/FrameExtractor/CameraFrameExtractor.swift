//
//  CameraFrameExtractor.swift
//  CrowdCount
//
//  Inspired by https://medium.com/ios-os-x-development/ios-camera-frames-extraction-d2c0f80ed05a
//

import UIKit
import AVFoundation
import RxSwift

class CameraFrameExtractor: NSObject, FrameExtractor, AVCaptureVideoDataOutputSampleBufferDelegate {
    var orientation: AVCaptureVideoOrientation = AVCaptureVideoOrientation.portrait
    let frames: Observable<UIImage>
    var isEnabled: Bool {
        get {
            return connection?.isEnabled == true
        }
        set(isEnabled) {
            connection?.isEnabled = isEnabled
        }
    }
    
    private let subject = PublishSubject<UIImage>()
    private let position = AVCaptureDevice.Position.back
    private let quality = AVCaptureSession.Preset.hd1280x720
    
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let context = CIContext()
    private var connection: AVCaptureConnection?
    
    private let sessionQueue = DispatchQueue(label: "CameraFrameExtractor session queue")
    private let sampleBufferCallbackQueue = DispatchQueue(label: "CameraFrameExtractor sample buffer")
    
    override init() {
        frames = subject
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            self.configureSession()
            self.captureSession.startRunning()
        }
    }
    
    // MARK: AVSession configuration
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    private func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    private func configureSession() {
        guard permissionGranted else { return }
        captureSession.sessionPreset = quality
        guard let captureDevice = selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: sampleBufferCallbackQueue)
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = orientation
        connection.isVideoMirrored = position == .front
        self.connection = connection
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position)
    }
    
    // MARK: Sample buffer to UIImage conversion
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = orientation
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        subject.onNext(uiImage)
    }
}
