//
//  BigLetterView.swift
//  TypingTutor
//
//  Created by 布川祐人 on 2018/01/22.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class BigLetterView: NSView {
    
    @objc
    var bold : Bool = false {
        didSet {
            prepareAttributes()
            self.needsDisplay = true
        }
    }

    @objc
    var italic : Bool = false {
        didSet {
            prepareAttributes()
            self.needsDisplay = true
        }
    }

    
    var bgColor : NSColor {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var string : NSString {
        didSet {
            NSLog("The string is now %@", string)
            self.needsDisplay = true
        }
    }

    var attributes :[NSAttributedStringKey : Any]

    func prepareAttributes() {
        var font = NSFont.userFont(ofSize: 25)
        let fontManager = NSFontManager.shared

        if bold {
            font = fontManager.convert(font!, toHaveTrait: NSFontTraitMask.boldFontMask)
        }
        
        if italic {
            font = fontManager.convert(font!, toHaveTrait: NSFontTraitMask.italicFontMask)
        }
        
        attributes[.font] = font

        attributes[.foregroundColor] = NSColor.red
        
        // 課題1 : 文字を影付きで表示する
        let s = NSShadow()
        s.shadowOffset = NSSize(width: 4, height: -4)
        s.shadowBlurRadius = 2.0
        attributes[NSAttributedStringKey.shadow] = s
        

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
        self.string = insertString as! NSString
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
    
    // MARK: Pasteboard
    func writeToPasteboard(_ pb : NSPasteboard) {
        pb.clearContents()
        pb.writeObjects([string as NSPasteboardWriting])
    }
    
    func readFromPasteboard(_ pb: NSPasteboard) -> Bool {
        let classes = [NSString.self]
        guard let objects = pb.readObjects(forClasses: classes, options: nil) else {
            return false
        }

        if objects.count > 0 {
            let value = objects[0] as! NSString
            
            if value.length == 1 {
                string = value
                return true
            }
        }

        return false
    }
    
    @IBAction func cut(_ sender:Any) {
        self.copy(sender)
        string = ""
    }
    
    @IBAction func copy(_ sender:Any) {
        let pb = NSPasteboard.general
        writeToPasteboard(pb)
    }

    @IBAction func paste(_ sender:Any) {
        let pb = NSPasteboard.general
        if (self.readFromPasteboard(pb)) {
            NSSound.beep()
        }
    }

    
}
