//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textField: NSTextField!
    
    var speechSynth : NSSpeechSynthesizer!

    override init() {
        speechSynth = NSSpeechSynthesizer(voice: nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func stopIt(_ sender: Any) {
        speechSynth.stopSpeaking()
    }
    
    @IBAction func sayIt(_ sender: Any) {
        let string : String = textField.stringValue
        
        if string.utf8.count == 0 {
            return
        }
        
        speechSynth.startSpeaking(string)
    }
}

