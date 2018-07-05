//: A Cocoa based Playground to experiment with crowd prediction

import AppKit
import CrowdCountApi
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)

let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let topView = views[0] as! NSView

 // Hardcoded to match MyView.xib
let imageWell = topView.subviews[0].subviews[1] as! NSImageView
imageWell.isEditable = true
let predictionLabel = topView.subviews[0].subviews[2] as! NSTextField

typealias ObserverCallback = (NSImage) -> Void

class ImageObserver: NSObject {
    var callback: ObserverCallback    
    init(_ callback: @escaping ObserverCallback) {
        self.callback = callback
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let newImage = change![NSKeyValueChangeKey.newKey] as! NSImage
        self.callback(newImage)
    }
}

let predictor = FriendlyPredictor()
let observer = ImageObserver({ image in
    predictionLabel.stringValue = "Predicting..."

    DispatchQueue.global().async {
        var result: Double = 0
        let duration = Duration.measure("Prediction", block: {
            result = predictor.predict(image: image)
        })
        
        DispatchQueue.main.async {
            predictionLabel.stringValue = String.init(format: "Count: %f, Duration: %f seconds", result, duration)
        }
    }
})
imageWell.addObserver(observer, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)

// Present the view in Playground
PlaygroundPage.current.liveView = topView
