//
//  ViewController.swift
//  CrowdCountMac
//
//  Created by Dimitri Roche on 8/12/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import AppKit
import Cartography
import CrowdCountApiMac
import Promises

// Ported from the Prediction.playground because compilation and linking
// of playgrounds was just too flaky. "error: Couldn't lookup symbols", etc
class DragDropViewController: NSViewController {
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var imageWell: NSImageView!
    @IBOutlet weak var predictionLabel: NSTextField!
    
    let predictor = FriendlyPredictor()
    var predictionGrid: NSGridView?, classificationGrid: NSGridView?
    
    override func viewDidAppear() {
        super.viewDidAppear()
        imageWell.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        predictionLabel.stringValue = "Predicting..."
        removeFromPlayground(predictionGrid)
        removeFromPlayground(classificationGrid)
        
        let image = change![NSKeyValueChangeKey.newKey] as! NSImage
        all(
            predictor.predictAllPromise(image: image, on: .global()),
            predictor.classifyPromise(image: image, on: .global())
            ).then(on: .main) { predictions, classification in
                self.classificationGrid = self.generateClassificationGrid(classification)
                self.predictionGrid = self.generatePredictionGrid(predictions)
                self.view.updateConstraintsForSubtreeIfNeeded()
        }    }
    
    private func generatePredictionGrid(_ predictions: [FriendlyPrediction]) -> NSGridView {
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
            gv.height >= 600
        }
        return gridView
    }
    
    private func generateClassificationGrid(_ classification: FriendlyClassification) -> NSGridView {
        predictionLabel.stringValue = "Winning Classification: " + classification.classification + "(scroll down)"
        print("Probabilities", classification.probabilities)
        let labels: [[NSView]] = classification.probabilities.map { tuple -> [NSView] in
            let (key, value) = tuple
            return [NSTextField(labelWithString: key), NSTextField(labelWithString: String.init(reflecting: value))]
        }
        let gridView = NSGridView(views: labels)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(600), for: .horizontal)
        gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(600), for: .vertical)
        
        stackView.addArrangedSubview(gridView)
        return gridView
    }
    
    private func removeFromPlayground(_ view: NSView?) {
        if view != nil {
            stackView.removeArrangedSubview(view!)
            view!.removeFromSuperview()
        }
    }
}

func nslabel(_ label: String) -> NSTextField { return NSTextField(labelWithString: label) }

func nsimage(_ prediction: FriendlyPrediction) -> NSView {
    var image: NSImage?
    Duration.measure("multiarray to grayscale") {
        image = prediction.densityMap.copy().normalize().image(offset: 0, scale: 255)
        drawBoundingBoxes(image!, prediction.boundingBoxes)
    }
    
    return NSImageView(image: image!.flipVertically())
}

func drawBoundingBoxes(_ image: NSImage, _ boundingBoxes: [CGRect]) {
    // Map the bounding boxes to density map dimensions 225 x 168
    let xfactor = CGFloat(FriendlyPredictor.DensityMapWidth)
    let yfactor = CGFloat(FriendlyPredictor.DensityMapHeight)
    image.lockFocus()
    NSColor.white.set()
    for bb in boundingBoxes {
        let rect = NSRect(x: bb.minX * xfactor, y: bb.minY*yfactor, width: (bb.maxX-bb.minX)*xfactor, height: (bb.maxY-bb.minY)*yfactor)
        __NSFrameRectWithWidth(rect, 2)
    }
    image.unlockFocus()
}
