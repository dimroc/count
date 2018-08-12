//
//  AppDelegate.swift
//  CrowdCountMac
//
//  Created by Dimitri Roche on 8/12/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Cocoa
import Cartography

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let vc = DragDropViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentViewController = vc
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
