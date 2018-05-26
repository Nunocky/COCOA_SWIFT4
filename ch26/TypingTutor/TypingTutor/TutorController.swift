//
//  TutorController.swift
//  TypingTutor
//
//  Created by 布川祐人 on 2018/01/27.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class TutorController: NSObject {
    @IBOutlet weak var inLetterView : BigLetterView!
    @IBOutlet weak var outLetterView : BigLetterView!
    @IBOutlet weak var speedSheet : NSWindow!

    var lastIndex : Int
    var letters : [NSString]
    
    var startTime : TimeInterval = 0
    
    @objc
    var elapsedTime : TimeInterval = 0
    
    @objc
    var timeLimit : TimeInterval
    
    var timer : Timer?
    
    override init() {
        lastIndex = 0
        timeLimit = 5.0
        letters = ["a", "s", "d", "f", "j", "k", "l", ";"]
        super.init()
    }
    
    override func awakeFromNib() {
        showAnotherLetter()
    }
    
    @IBAction func stopGo(_ sender : Any) {
        resetElapsedTime()
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(checkThem),
                                         userInfo: nil,
                                         repeats: true)
        }
        else {
            NSLog("Stopping")
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc
    func checkThem(timer: Timer) {
        if (inLetterView.string.isEqual(to: outLetterView.string)) {
            showAnotherLetter()
        }
        
        updateElapsedTime()
        
        if (elapsedTime >= timeLimit) {
            NSSound.beep()
            resetElapsedTime()
        }
    }
    
    func updateElapsedTime() {
        self.willChangeValue(forKey: "elapsedTime")
        elapsedTime = Date.timeIntervalSinceReferenceDate - startTime
        self.didChangeValue(forKey: "elapsedTime")
    }
    
    func resetElapsedTime() {
        startTime = Date.timeIntervalSinceReferenceDate
        updateElapsedTime()
    }
    
    func showAnotherLetter() {
        var x = lastIndex
        while (x == lastIndex) {
            x = Int(arc4random_uniform(UInt32(letters.count)))
        }
        lastIndex = x
        outLetterView.string = letters[lastIndex]
    }
    
    
    // MARK: - 25章
    @IBAction func showSpeesSheet (_ sender : Any) {
        // 'beginSheet(_:modalFor:modalDelegate:didEnd:contextInfo:)' was deprecated in OS X 10.10:
        // Use -[NSWindow beginSheet:completionHandler:] instead

        if let window = inLetterView.window {
            window.beginSheet(speedSheet, completionHandler: { (response) in
//                if response == NSApplication.ModalResponse.OK {
//                }
            })
        }
    }
    
    @IBAction func endSpeedSheet (_ sender : Any) {
        // 'endSheet' was deprecated in OS X 10.10: Use -[NSWindow endSheet:] instead
        //NSApp.endSheet(speedSheet)
        if let window = inLetterView.window {
            window.endSheet(speedSheet)
        }
    }

    @objc dynamic
    func control(_ control: NSControl,
                 didFailToFormatString string: String,
                 errorDescription error: String?) -> Bool {
        NSLog("TutorController told that formatting of %@ failed: %@", string, error ?? "")
        return false
    }
}
