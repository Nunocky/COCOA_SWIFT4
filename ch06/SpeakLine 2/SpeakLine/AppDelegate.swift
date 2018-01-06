//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDataSource {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textField: NSTextField!
    
    var speechSynth : NSSpeechSynthesizer!
    var voices : [NSSpeechSynthesizer.VoiceName]!

    override init() {
        super.init()
        speechSynth = NSSpeechSynthesizer(voice: nil)
        speechSynth.delegate = self
        
        voices = NSSpeechSynthesizer.availableVoices
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
    
    // MARK: - NSSpeechSynthesizerDelegate
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        let v = finishedSpeaking ? 1 : 0
        NSLog("finishedSpeaking=%d", v)
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return voices[row]
    }

}

