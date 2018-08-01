//
//  VideoFrameExtractor.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/23/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import CrowdCountApi

class VideoFrameExtractor: FrameExtractor {
    var frames: Observable<UIImage> {
        return subject
    }
    var orientation: AVCaptureVideoOrientation = AVCaptureVideoOrientation.landscapeLeft
    var isEnabled: Bool {
        get { return cyclingProxy?.isEnabled == true }
        set(isEnabled) { cyclingProxy?.isEnabled = isEnabled }
    }

    private let subject = PublishSubject<UIImage>()
    private var cyclingProxy: CyclingReplayProxy<UIImage>?
    private let disposeBag = DisposeBag()

    private let availableVideos = [
        "https://dimroc-public.s3.amazonaws.com/people-dancing-720p-10s.mov",
        "https://dimroc-public.s3.amazonaws.com/people-dancing.mp4"
    ]

    init() {
        startPushingVideo(URL(string: availableVideos[0])!)
    }

    private func startPushingVideo(_ url: URL) {
        let asset = AVAsset(url: url)
        if !asset.isPlayable {
            print("Unable to play asset \(url)")
            return
        }
        var frameForTimes = [NSValue]()
        let totalTimeLength = Int(asset.duration.seconds * Double(asset.duration.timescale))
        let fps: Double = 24
        let sampleCounts = Int(asset.duration.seconds * fps)
        let step = totalTimeLength / sampleCounts
        print("\(url) has \(sampleCounts) frames and \(asset.duration)")

        for i in 0 ..< sampleCounts {
            let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(asset.duration.timescale))
            frameForTimes.append(NSValue(time: cmTime))
        }

        let decoded = PublishSubject<UIImage>()
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceAfter = CMTime.zero
        generator.requestedTimeToleranceBefore = CMTime.zero
        var count = 0
        generator.generateCGImagesAsynchronously(forTimes: frameForTimes) { _, cgImage, _, _, err in
            count+=1
            if err != nil {
                print("Error extracting frame: \(err!)")
            } else {
                decoded.onNext(UIImage(cgImage: cgImage!))
            }

            if count == frameForTimes.count {
                print("Completed decoding \(url)")
                decoded.onCompleted()
            }
        }

        let interval = Observable<Int>
            .interval(1.0/fps, scheduler: SerialDispatchQueueScheduler(qos: .utility))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))

        cyclingProxy = CyclingReplayProxy(observable: decoded, pace: interval, samples: Int(fps*5))
        cyclingProxy!.observable.bind(to: self.subject).disposed(by: disposeBag)
    }
}
