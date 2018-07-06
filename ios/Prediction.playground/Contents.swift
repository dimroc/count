//: A Cocoa based Playground to experiment with crowd prediction

import AppKit
import Cartography
import CrowdCountApi
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)

let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let topView = views[0] as! NSView

// Hardcoded to match MyView.xib
let stackView = topView.subviews[0] as! NSStackView
let imageWell = stackView.subviews[1] as! NSImageView
imageWell.isEditable = true
let predictionLabel = stackView.subviews[2] as! NSTextField

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

func generatePredictionGrid(_ result: Double) -> NSGridView {
    let label = NSTextField(labelWithString: "tens")
    let count = NSTextField(labelWithString: String.init(format: "%f", result))

    let gridView = NSGridView(views: [[label, count]])
    gridView.translatesAutoresizingMaskIntoConstraints = false
    gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(600), for: .horizontal)
    gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(600), for: .vertical)

    stackView.addArrangedSubview(gridView)
    constrain(gridView) { gv in
        align(left: gv, gv.superview!)
        align(right: gv, gv.superview!)
    }
    return gridView
}

var grid: NSGridView? = nil
let predictor = FriendlyPredictor()
let observer = ImageObserver({ image in
    predictionLabel.stringValue = "Predicting..."
    if grid != nil {
        stackView.removeArrangedSubview(grid!)
        grid!.removeFromSuperview()
    }

    DispatchQueue.global().async {
        var result: Double = 0
        let duration = Duration.measure("Prediction", block: {
            result = predictor.predict(image: image)
        })
        
        DispatchQueue.main.async {
            predictionLabel.stringValue = String.init(format: "Duration: %f seconds", result, duration)
            grid = generatePredictionGrid(result)
        }
    }
})
imageWell.addObserver(observer, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)

// Present the view in Playground
PlaygroundPage.current.liveView = topView
