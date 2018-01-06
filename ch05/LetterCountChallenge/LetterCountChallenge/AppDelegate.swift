//
//  AppDelegate.swift
//  LetterCountChallenge
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var msgLabel: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func countCharacters(_ sender: Any) {
        let str = textField.stringValue
        let count = str.count
        let msg = String.init(format: "'%@' has %d characters",
                              str,
                              count)
        
        msgLabel.stringValue = msg
    }
}

