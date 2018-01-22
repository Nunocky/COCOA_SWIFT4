//
//  BigLetterView.swift
//  TypingTutor
//
//  Created by 布川祐人 on 2018/01/22.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class BigLetterView: NSView {
    
    var bgColor : NSColor = NSColor.yellow {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var string : String = "" {
        didSet {
            self.needsDisplay = true
            NSLog("The string is now %@", string)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let bounds = self.bounds
        bgColor.set()
        NSBezierPath.fill(bounds)
        
        if self.window?.firstResponder == self {
            NSColor.keyboardFocusIndicatorColor.set()
            NSBezierPath.defaultLineWidth = 4.0
            NSBezierPath.stroke(bounds)
        }
    }
 
    override var isOpaque: Bool {
        get {
            return true
        }
    }
    
    override var acceptsFirstResponder: Bool {
        get {
            NSLog("Accepting")
            return true
        }
    }
    
    override func resignFirstResponder() -> Bool {
        NSLog("Resigning")
        self.needsDisplay = true
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        NSLog("Becoming")
        self.needsDisplay = true
        return true
    }
    

    override func keyDown(with event: NSEvent) {
            self.interpretKeyEvents([event])
    }
    
    override func insertText(_ insertString: Any) {
        self.string = insertString as! String
    }
    
    override func insertTab(_ sender: Any?) {
        self.window?.selectKeyView(following: self)
    }
    
    override func insertBacktab(_ sender: Any?) {
        self.window?.selectKeyView(preceding: self)
    }
    
    override func deleteBackward(_ sender: Any?) {
        self.string = ""
    }
    
    override func viewDidMoveToWindow() {

        let ta = NSTrackingArea(rect: NSRect.zero,
                                options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect] ,
                                owner: self,
                                userInfo: nil)
        self.addTrackingArea(ta)
        
        self.window?.acceptsMouseMovedEvents = true
    }

    var isHighlighted = false
    
    override func mouseEntered(with event: NSEvent) {
        NSLog("mouse entered")
        isHighlighted = true
        self.needsDisplay = true
    }
    
    override func mouseExited(with event: NSEvent) {
        NSLog("mouse exited")
        isHighlighted = false
        self.needsDisplay = true

    }
}
