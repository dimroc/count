//: A Cocoa based Playground to experiment with crowd prediction

import AppKit
import Cartography
import CrowdCountApi
import PlaygroundSupport
import Promises

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)

let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let topView = views[0] as! NSView

// Hardcoded to match MyView.xib
let stackView = topView.subviews[0] as! NSStackView
let imageWell = stackView.subviews[1] as! NSImageView
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

func nslabel(_ label: String) -> NSTextField { return NSTextField(labelWithString: label) }

func nsimage(_ prediction: FriendlyPrediction) -> NSView {
    var image: NSImage? = nil
    Duration.measure("multiarray to grayscale") {
        image = prediction.density_map.copy().normalize().image(offset: 0, scale: 255)
    }
    
    return NSImageView(image: image!.flipVertically())
}

func generatePredictionGrid(_ predictions: [FriendlyPrediction]) -> NSGridView {
    print("Generating prediction grid")
    let headers: [[NSView]] = [[nslabel("Strategy"), nslabel("Duration (s)"), nslabel("Count")]]
    let labels = predictions.map { prediction -> [NSView] in
        let label = nslabel(prediction.name)
        let duration = nslabel(String.init(format: "%f", prediction.duration))
        let count = nslabel(String.init(format: "%f", prediction.count))
        return [label, duration, count]
    }
    
    let images = predictions.map { prediction -> [NSView] in
        print("mounting image for...", prediction.name)
        return [nsimage(prediction)]
    }

    let zipped = zip(labels, images)
    let reduced: [[NSView]] = zipped.reduce([[NSView]]()) { acc, entry in
        acc + [entry.0, entry.1]    // convert from tuples to array
    }

    let gridView = NSGridView(views: headers + reduced)
    gridView.translatesAutoresizingMaskIntoConstraints = false
    gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(600), for: .horizontal)
    gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(600), for: .vertical)

    stackView.addArrangedSubview(gridView)
    constrain(gridView) { gv in
        align(leading: gv, gv.superview!)
        align(trailing: gv, gv.superview!)
        gv.height >= 400
    }
    stackView.updateConstraintsForSubtreeIfNeeded()
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
    
    predictor.predictAllPromise(image: image, on: .global()).then(on: .main) { predictions in
        grid = generatePredictionGrid(predictions)
    }
})
imageWell.addObserver(observer, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)

// Present the view in Playground
PlaygroundPage.current.liveView = topView
