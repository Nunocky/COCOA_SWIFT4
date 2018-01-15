//
//  StretchView.swift
//  DrawingFun
//
//  Created by 布川祐人 on 2018/01/15.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class StretchView: NSView {

    var path : NSBezierPath
    
    @objc dynamic
    var opacity : CGFloat {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var image : NSImage? {
        didSet{
            self.needsDisplay = true
        }
    }
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//    }
    
    required init?(coder decoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        path = NSBezierPath()
        opacity = 1.0
        image = nil
        super.init(coder: decoder)

        path.lineWidth = 3.0
        var p = randomPoint()
        path.move(to: p)
        for _ in 0 ..< 15 {
            p = randomPoint()
            path.line(to: p)
        }
        
        path.close()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        NSColor.green.set()
        NSBezierPath.fill(self.bounds)
        
        NSColor.white.set()
        path.stroke()
        //path.fill()
        
        if let img = image {
            var imageRect = NSRect()
            imageRect.origin = NSZeroPoint;
            imageRect.size = img.size
            
            let drawingRect = imageRect
            img.draw(in: drawingRect, from: imageRect, operation: .sourceOver, fraction: opacity)
        }
        
    }

    func randomPoint() -> NSPoint {
        var result = NSPoint()
        let r = self.bounds
        
        result.x = r.origin.x + (CGFloat)(arc4random() % (UInt32)(r.size.width))
        result.y = r.origin.y + (CGFloat)(arc4random() % (UInt32)(r.size.height))
        return result
    }
    
    // ビューを反転系で扱う
//    override var isFlipped: Bool {
//        get {
//            return true
//        }
//    }
    
    // MARK: - Events
    override func mouseDown(with event: NSEvent) {
        NSLog("mouseDown: %ld", event.clickCount)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let p = event.locationInWindow
        NSLog("mouseDragged: %@", NSStringFromPoint(p))
    }
    
    
    override func mouseUp(with event: NSEvent) {
        NSLog("mouseUp")
    }
}

