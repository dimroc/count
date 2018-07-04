// A Cocoa based Playground to drop images for crowd prediction

import AppKit
import Cocoa
import CrowdCountApi
import PlaygroundSupport

// Support Foundation calls on String
public extension String { public var ns: NSString {return self as NSString} }

/// Custom Labeled Playground-Based Drag-and-Drop window
public class DropView: NSTextField {
    
    // Default action handler
    public var handler: ([String]) -> Void = { paths in Swift.print(paths) }
    
    // Drag and drop notification
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation { return NSDragOperation.copy }
    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation { return NSDragOperation.copy }
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard
        guard let paths = pboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String] else { return false }
        handler(paths)
        return true
    }
    
    public required init?(coder: NSCoder) { super.init(coder: coder) }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // Presentation
        stringValue = "Drop Here"; isEditable = false
        font = NSFont(name: "Palatino", size: 48.0); alignment = .center
        wantsLayer = true; layer?.backgroundColor = NSColor.white.cgColor
        
        // Register for file name drags
        registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: kUTTypeFileURL as String), NSPasteboard.PasteboardType(rawValue: kUTTypeItem as String)])
    }
}

// Establish drop view
let dropView = DropView(frame: NSRect(x: 0, y: 0, width: 600, height: 200))
dropView.stringValue = "Drop Pictures"
dropView.handler = {
    // Print out each file name and image size
    $0.forEach {
        if let image = NSImage(contentsOfFile: $0) {
            Swift.print($0.ns.lastPathComponent, image.size)
        } else {
            Swift.print($0.ns.lastPathComponent, "is not an image")
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.liveView = dropView
PlaygroundPage.current.needsIndefiniteExecution = true

