//
//  AppDelegate.swift
//  DrawingFun
//
//  Created by 布川祐人 on 2018/01/15.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var stretchView: StretchView!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showOpenPanel(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = NSImage.imageTypes
        panel.beginSheetModal(for: stretchView.window!) { (response) in
            if response == NSApplication.ModalResponse.OK {
                let image = NSImage(contentsOf: panel.url!)
                self.stretchView.image = image
            }
            
        }
        
    }
    
}

