//
//  MultiArray+NSImage.swift
//  CrowdCountApi
//
//  Created by Dimitri Roche on 7/5/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import AppKit
import Foundation

extension MultiArray {
    /**
     Converts the multi-array to a NSImage.
     
     Use the `offset` and `scale` parameters to put the values from the array in
     the range [0, 255]. The offset is added first, then the result is multiplied
     by the scale.
     
     For example: if the range of the data is [0, 1), use `offset: 0` and
     `scale: 255`. If the range is [-1, 1], use `offset: 1` and `scale: 127.5`.
     */
    public func image(offset: T, scale: T) -> NSImage? {
        let (b, w, h) = toRawBytesGray(offset: offset, scale: scale)!
        print("converting from multiarray to nsimage with min", self.min(), " max", self.max(), " and dimensions", w, h)
        return imageFromPixels(size: NSSize(width: w, height: h), pixels: b, width: w, height: h)
    }
    
    /**
     Converts a single channel from the multi-array to a grayscale UIImage.
     
     - Note: The multi-array must have shape (channels, height, width). If your
     array has a different shape, use `reshape()` or `transpose()` first.
     */
    public func image(channel: Int, offset: T, scale: T) -> NSImage? {
        guard shape.count == 3 else {
            print("Expected a multi-array with 3 dimensions, got \(shape)")
            return nil
        }
        guard channel >= 0 && channel < shape[0] else {
            print("Channel must be between 0 and \(shape[0] - 1)")
            return nil
        }
        
        let height = shape[1]
        let width = shape[2]
        var a = MultiArray<T>(shape: [height, width])
        for y in 0..<height {
            for x in 0..<width {
                a[y, x] = self[channel, y, x]
            }
        }
        return a.image(offset: offset, scale: scale)
    }
    
    func imageFromPixels(size: NSSize, pixels: UnsafePointer<UInt8>, width: Int, height: Int)-> NSImage {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let bitsPerComponent = 8 //number of bits in UInt8
        let bitsPerPixel = 1 * bitsPerComponent // Grayscale uses 1 components
        let bytesPerRow = bitsPerPixel * width / 8 // bitsPerRow / 8 (in some cases, you need some paddings)
        let providerRef = CGDataProvider(
            data: NSData(bytes: pixels, length: height * bytesPerRow)
        )
        
        let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        return NSImage(cgImage: cgim!, size: size)
    }

}
