//
//  NSImage+resize.swift
//  CrowdCountApiMac
//
//  Created by Dimitri Roche on 7/5/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import AppKit
import Foundation

extension NSImage {
    public func resizeImage(_ newSize: CGSize) -> NSImage {
        let destSize = NSSize(width: newSize.width, height: newSize.height)
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        self.draw(in: NSRect(x: 0, y: 0, width: destSize.width, height: destSize.height), from: NSRect(x: 0, y: 0, width: self.size.width, height: self.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return newImage
    }

    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)

        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {return nil}

        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)

        let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = graphicsContext
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        NSGraphicsContext.restoreGraphicsState()

        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return resultPixelBuffer
    }

    public func flipVertically() -> NSImage {
        let existingImage: NSImage = self
        let existingSize: NSSize = existingImage.size
        let newSize: NSSize = NSSize(width: (existingSize.width), height: (existingSize.height))
        let flipedImage = NSImage(size: newSize)
        flipedImage.lockFocus()

        let t = NSAffineTransform.init()
        t.translateX(by: 0, yBy: (existingSize.height))
        t.scaleX(by: 1.0, yBy: -1.0)
        t.concat()

        let rect: NSRect = NSRect(x: 0, y: 0, width: (newSize.width), height: (newSize.height))
        existingImage.draw(at: NSPoint.zero, from: rect, operation: .sourceOver, fraction: 1.0)
        flipedImage.unlockFocus()
        return flipedImage
    }
}
