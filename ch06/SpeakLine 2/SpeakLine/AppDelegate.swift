//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDataSource , NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    var speechSynth : NSSpeechSynthesizer!
    var voices : [NSSpeechSynthesizer.VoiceName]!

    override init() {
        super.init()
        speechSynth = NSSpeechSynthesizer(voice: nil)
        speechSynth.delegate = self
        
        voices = NSSpeechSynthesizer.availableVoices
    }

    override func awakeFromNib() {
        let defaultVoice = NSSpeechSynthesizer.defaultVoice
        guard let defaultRow = voices.index(of: defaultVoice) else {
            return
        }
        
        let indices = IndexSet(integer: defaultRow)
        tableView.selectRowIndexes(indices, byExtendingSelection: false)
        tableView.scrollRowToVisible(defaultRow)
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
        stopButton.isEnabled = true
        speakButton.isEnabled = false
    }
    
    // MARK: - NSSpeechSynthesizerDelegate
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        //let v = finishedSpeaking ? 1 : 0
        //NSLog("finishedSpeaking=%d", v)
        stopButton.isEnabled = false
        speakButton.isEnabled = true
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let vn : NSSpeechSynthesizer.VoiceName = voices[row]
        let dict = NSSpeechSynthesizer.attributes(forVoice: vn)
        return dict[NSSpeechSynthesizer.VoiceAttributeKey.name]
    }

    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        if row == -1 {
            return
        }

        let selectedVoice = voices[row]
        speechSynth.setVoice(selectedVoice)
        NSLog("new voice = %@", selectedVoice.rawValue)
    }

}

