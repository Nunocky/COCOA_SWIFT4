//
//  BigLetterView.swift
//  TypingTutor
//
//  Created by 布川祐人 on 2018/01/22.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class BigLetterView: NSView {
    
    var bgColor : NSColor {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var string : String {
        didSet {
            NSLog("The string is now %@", string)
            self.needsDisplay = true
        }
    }

    var attributes :[NSAttributedStringKey : Any]

    func prepareAttributes() {
        attributes[.font] = NSFont.userFont(ofSize: 25)
        attributes[.foregroundColor] = NSColor.red
    }
    
//    override init(frame frameRect: NSRect) {
//    }
    
    required init?(coder decoder: NSCoder) {
        string = ""
        bgColor = NSColor.yellow
        attributes = [:]
        super.init(coder: decoder)
        prepareAttributes()
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let bounds = self.bounds
        bgColor.set()
        NSBezierPath.fill(bounds)
        
        self.drawStringCenteredIn(r: bounds)
        
        if self.window?.firstResponder == self  && NSGraphicsContext.currentContextDrawingToScreen() {
            NSGraphicsContext.saveGraphicsState()
            NSFocusRingPlacement.only.set()
            NSBezierPath.stroke(bounds)
            NSGraphicsContext.restoreGraphicsState()
        }
    }

    func drawStringCenteredIn(r : NSRect) {
        let strSize = string.size(withAttributes: attributes)
        var strOrigin = NSPoint()
        strOrigin.x = r.origin.x + (r.size.width - strSize.width) / 2
        strOrigin.y = r.origin.y + (r.size.height - strSize.height) / 2
        string.draw(at: strOrigin, withAttributes: attributes)
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
        //self.needsDisplay = true
        self.setKeyboardFocusRingNeedsDisplay(self.bounds)
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
    
    @IBAction func savePDF(_ sender : Any) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["pdf"]
        
        guard let window = self.window else {
            return
        }


        panel.beginSheetModal(for: window) { (response) in
            if response == NSApplication.ModalResponse.OK {
                let r = self.bounds
                let data = self.dataWithPDF(inside: r)
                
                guard let url = panel.url else {
                    return
                }

                do {
                    try data.write(to: url)
                }
                catch {
                    //NSLog("%@", error.localizedDescription)
                    let a = NSAlert(error: error)
                    a.runModal()
                }
            }
        }
        
        
    }
}
