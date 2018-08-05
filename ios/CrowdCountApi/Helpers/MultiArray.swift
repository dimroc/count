/*
  Copyright (c) 2017 M.I. Hollemans

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
*/

import Foundation
import CoreML
import Swift

public protocol MultiArrayType: Comparable {
  static var multiArrayDataType: MLMultiArrayDataType { get }
  static func +(lhs: Self, rhs: Self) -> Self
  static func -(lhs: Self, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Self) -> Self
  static func /(lhs: Self, rhs: Self) -> Self
  init(_: Int)
  var toUInt8: UInt8 { get }
}

extension Double: MultiArrayType {
  public static var multiArrayDataType: MLMultiArrayDataType { return .double }
  public var toUInt8: UInt8 { return UInt8(self) }
}

extension Float: MultiArrayType {
  public static var multiArrayDataType: MLMultiArrayDataType { return .float32 }
  public var toUInt8: UInt8 { return UInt8(self) }
}

extension Int32: MultiArrayType {
  public static var multiArrayDataType: MLMultiArrayDataType { return .int32 }
  public var toUInt8: UInt8 { return UInt8(self) }
}

/**
 Wrapper around MLMultiArray to make it more Swifty.
*/
public struct MultiArray<T: MultiArrayType> {
  public let array: MLMultiArray
  public let pointer: UnsafeMutablePointer<T>

  private(set) public var strides: [Int]
  private(set) public var shape: [Int]

  /**
   Creates a new multi-array filled with all zeros.
  */
  public init(shape: [Int]) {
    let m = try! MLMultiArray(shape: shape as [NSNumber], dataType: T.multiArrayDataType)
    self.init(m)
    memset(pointer, 0, MemoryLayout<T>.stride * count)
  }

  /**
   Creates a new multi-array initialized with the specified value.
  */
  public init(shape: [Int], initial: T) {
    self.init(shape: shape)
    for i in 0..<count {
      pointer[i] = initial
    }
  }

  /**
   Creates a multi-array that wraps an existing MLMultiArray.
  */
  public init(_ array: MLMultiArray) {
    self.init(array, array.shape as! [Int], array.strides as! [Int])
  }

  init(_ array: MLMultiArray, _ shape: [Int], _ strides: [Int]) {
    self.array = array
    self.shape = shape
    self.strides = strides
    pointer = UnsafeMutablePointer<T>(OpaquePointer(array.dataPointer))
  }

  /**
   Returns the number of elements in the entire array.
  */
  public var count: Int {
    return shape.reduce(1, *)
  }

  public subscript(a: Int) -> T {
    get { return pointer[a] }
    set { pointer[a] = newValue }
  }

  public subscript(a: Int, b: Int) -> T {
    get { return pointer[a*strides[0] + b*strides[1]] }
    set { pointer[a*strides[0] + b*strides[1]] = newValue }
  }

  public subscript(a: Int, b: Int, c: Int) -> T {
    get { return pointer[a*strides[0] + b*strides[1] + c*strides[2]] }
    set { pointer[a*strides[0] + b*strides[1] + c*strides[2]] = newValue }
  }

  public subscript(a: Int, b: Int, c: Int, d: Int) -> T {
    get { return pointer[a*strides[0] + b*strides[1] + c*strides[2] + d*strides[3]] }
    set { pointer[a*strides[0] + b*strides[1] + c*strides[2] + d*strides[3]] = newValue }
  }

  public subscript(a: Int, b: Int, c: Int, d: Int, e: Int) -> T {
    get { return pointer[a*strides[0] + b*strides[1] + c*strides[2] + d*strides[3] + e*strides[4]] }
    set { pointer[a*strides[0] + b*strides[1] + c*strides[2] + d*strides[3] + e*strides[4]] = newValue }
  }

  public subscript(indices: [Int]) -> T {
    get { return pointer[offset(for: indices)] }
    set { pointer[offset(for: indices)] = newValue }
  }

  func offset(for indices: [Int]) -> Int {
    var offset = 0
    for i in 0..<indices.count {
      offset += indices[i] * strides[i]
    }
    return offset
  }

  /**
   Returns a transposed version of this array. NOTE: The new array still uses
   the same underlying storage (the same MLMultiArray object).
  */
  public func transposed(_ order: [Int]) -> MultiArray {
    precondition(order.count == strides.count)
    var newShape = shape
    var newStrides = strides
    for i in 0..<order.count {
      newShape[i] = shape[order[i]]
      newStrides[i] = strides[order[i]]
    }
    return MultiArray(array, newShape, newStrides)
  }

  /**
   Changes the number of dimensions and their sizes.
  */
  public func reshaped(_ dimensions: [Int]) -> MultiArray {
    let newCount = dimensions.reduce(1, *)
    precondition(newCount == count, "Cannot reshape \(shape) to \(dimensions)")

    var newStrides = [Int](repeating: 0, count: dimensions.count)
    newStrides[dimensions.count - 1] = 1
    for i in stride(from: dimensions.count - 1, to: 0, by: -1) {
      newStrides[i - 1] = newStrides[i] * dimensions[i]
    }

    return MultiArray(array, dimensions, newStrides)
  }

    public func max() -> T {
        var m: T = T.init(0)
        for i in 0..<count where pointer[i] > m {
            m = pointer[i]
        }
        return m
    }

    public func min() -> T {
        var m: T = T.init(Int.max)
        for i in 0..<count where  pointer[i] < m {
            m = pointer[i]
        }
        return m
    }

    public func copy() -> MultiArray {
        let copy = MultiArray(shape: shape)
        for i in 0..<count {
            copy.pointer[i] = pointer[i]
        }
        return copy
    }

    public func normalize() -> MultiArray {
        let max = self.max()
        let min = self.min()
        if max - min == T.init(0) {
            return self
        }

        let multiplier = T.init(1)/(max-min)
        print("normalizing with min max multiplier", min, max, multiplier)

        for i in 0..<count {
            pointer[i] = (pointer[i] - min) * multiplier
        }
        return self
    }

    public func multiply(_ factor: T) -> MultiArray {
        for i in 0..<count {
            pointer[i] = pointer[i] * factor
        }
        return self
    }
}

extension MultiArray: CustomStringConvertible {
  public var description: String {
    return description([])
  }

  func description(_ indices: [Int]) -> String {
    func indent(_ x: Int) -> String {
      return String(repeating: " ", count: x)
    }

    // This function is called recursively for every dimension.
    // Add an entry for this dimension to the end of the array.
    var indices = indices + [0]

    let d = indices.count - 1          // the current dimension
    let N = shape[d]                   // how many elements in this dimension

    var s = "["
    if indices.count < shape.count {   // not last dimension yet?
      for i in 0..<N {
        indices[d] = i
        s += description(indices)      // then call recursively again
        if i != N - 1 {
          s += ",\n" + indent(d + 1)
        }
      }
    } else {                           // the last dimension has actual data
      s += " "
      for i in 0..<N {
        indices[d] = i
        s += "\(self[indices])"
        if i != N - 1 {                // not last element?
          s += ", "
          if i % 11 == 10 {            // wrap long lines
            s += "\n " + indent(d + 1)
          }
        }
      }
      s += " "
    }
    return s + "]"
  }
}

extension MultiArray {
  /**
   Converts the multi-array into an array of RGBA pixels.

   - Note: The multi-array must have shape (3, height, width). If your array
     has a different shape, use `reshape()` or `transpose()` first.
  */
  public func toRawBytesRGBA(offset: T, scale: T)
                            -> (bytes: [UInt8], width: Int, height: Int)? {
    guard shape.count == 3 else {
      print("Expected a multi-array with 3 dimensions, got \(shape)")
      return nil
    }
    guard shape[0] == 3 else {
      print("Expected first dimension to have 3 channels, got \(shape[0])")
      return nil
    }

    let height = shape[1]
    let width = shape[2]
    var bytes = [UInt8](repeating: 0, count: height * width * 4)

    for h in 0..<height {
      for w in 0..<width {
        let r = (self[0, h, w] + offset) * scale
        let g = (self[1, h, w] + offset) * scale
        let b = (self[2, h, w] + offset) * scale

        let offset = h*width*4 + w*4
        bytes[offset + 0] = clamp(r, min: T(0), max: T(255)).toUInt8
        bytes[offset + 1] = clamp(g, min: T(0), max: T(255)).toUInt8
        bytes[offset + 2] = clamp(b, min: T(0), max: T(255)).toUInt8
        bytes[offset + 3] = 255
      }
    }
    return (bytes, width, height)
  }

  /**
   Converts the multi-array into an array of grayscale pixels.

   - Note: The multi-array must have shape (height, width). If your array
     has a different shape, use `reshape()` or `transpose()` first.
  */
  public func toRawBytesGray(offset: T, scale: T)
                            -> (bytes: [UInt8], width: Int, height: Int)? {
    guard shape.count == 2 else {
      print("Expected a multi-array with 2 dimensions, got \(shape)")
      return nil
    }

    let height = shape[0]
    let width = shape[1]
    var bytes = [UInt8](repeating: 0, count: height * width)

    for h in 0..<height {
      for w in 0..<width {
        let pixel = (self[h, w] + offset) * scale
        let offset = h*width + w
        bytes[offset] = clamp(pixel, min: T(0), max: T(255)).toUInt8
      }
    }
    return (bytes, width, height)
  }

    func getCGImageForRGBAData(width: Int, height: Int, data: NSData) -> CGImage {
        let pixelData = data.bytes
        let bytesPerPixel: Int = 4
        let scanWidth = bytesPerPixel * width

        let provider = CGDataProvider(dataInfo: nil, data: pixelData, size: height * scanWidth, releaseData: {_, _, _ in })!

        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)
        let renderingIntent = CGColorRenderingIntent.defaultIntent

        return CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: bytesPerPixel * 8, bytesPerRow: scanWidth, space: colorSpaceRef, bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false, intent: renderingIntent)!
    }

    func getCGImageforGrayscaleData(width: Int, height: Int, data: [UInt8]?) -> CGImage? {
        var imageRef: CGImage?
        if let data = data {
            let bitsPerComponent = 8
            let bytesPerPixel = 1
            let bitsPerPixel = bytesPerPixel * bitsPerComponent
            let bytesPerRow = bytesPerPixel * width
            let totalBytes = height * bytesPerRow
            let providerRef = CGDataProvider(dataInfo: nil, data: data, size: totalBytes, releaseData: {_, _, _ in })!

//            let providerRef = CGDataProviderCreateWithData(nil, data, totalBytes, nil)

            let colorSpaceRef = CGColorSpaceCreateDeviceGray()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
            imageRef = CGImage.init(width: width,
                                    height: height,
                                    bitsPerComponent: bitsPerComponent,
                                    bitsPerPixel: bitsPerPixel,
                                    bytesPerRow: bytesPerRow,
                                    space: colorSpaceRef,
                                    bitmapInfo: bitmapInfo,
                                    provider: providerRef,
                                    decode: nil,
                                    shouldInterpolate: false,
                                    intent: CGColorRenderingIntent.defaultIntent)
        }

        return imageRef
    }

    public func cgimage(offset: T, scale: T) -> CGImage? {
        print("cgimaging", shape)
        if shape.count == 3, let (b, w, h) = toRawBytesRGBA(offset: offset, scale: scale) {
            return getCGImageForRGBAData(width: w, height: h, data: NSData(bytes: b, length: b.count))
        } else if shape.count == 2, let (b, w, h) = toRawBytesGray(offset: offset, scale: scale) {
            print("converting to grayscale", w, h)
            return getCGImageforGrayscaleData(width: w, height: h, data: b)
        } else {
            return nil
        }
    }
}
