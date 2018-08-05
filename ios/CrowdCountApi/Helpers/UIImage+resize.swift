//
//  UIImage+resize.swift
//  CrowdCountApi
//
//  Created by Dimitri Roche on 7/1/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    // https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    public func resizeImageFill(_ newSize: CGSize) -> UIImage? {
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }

            return _scaleImage(getScaledRect(newSize))
        }

        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }

    public func resizeImageFit(_ newSize: CGSize) -> UIImage? {
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = min(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }

            return _scaleImage(getScaledRect(newSize))
        }

        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }

    public func isSameSize(_ newSize: CGSize) -> Bool {
        return size == newSize
    }

    private func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0)
        draw(in: scaledRect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
