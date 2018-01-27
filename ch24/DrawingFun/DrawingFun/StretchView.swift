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
    
    @objc // dynamic
    var opacity : CGFloat {
        didSet {
            self.needsDisplay = true
        }
    }
    
    var image : NSImage? {
        didSet{
            let imageSize = image!.size
            downPoint = NSZeroPoint
            currentPoint.x = downPoint.x + imageSize.width
            currentPoint.y = downPoint.y + imageSize.height
            self.needsDisplay = true
        }
    }
    
    var downPoint : NSPoint
    var currentPoint : NSPoint
    
    var currentRect : NSRect {
        get {
            let minX = min(downPoint.x, currentPoint.x)
            let maxX = max(downPoint.x, currentPoint.x)
            let minY = min(downPoint.y, currentPoint.y)
            let maxY = max(downPoint.y, currentPoint.y)
            return NSMakeRect(minX, minY, maxX - minX, maxY - minY)
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
        downPoint = NSZeroPoint
        currentPoint = NSZeroPoint
        
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
            
            //let drawingRect = imageRect
            let drawingRect = self.currentRect
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
    var timer : Timer?
    
    override func mouseDown(with event: NSEvent) {
        NSLog("mouseDown: %ld", event.clickCount)
        let p = event.locationInWindow
        downPoint = self.convert(p, from: nil)
        currentPoint = downPoint
        self.needsDisplay = true
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(timerEvent),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc
    func timerEvent(timer: Timer) {
        if let event = NSApp.currentEvent {
            self.autoscroll(with: event)
            self.needsDisplay = true
        }
    }
    
//    override func mouseDragged(with event: NSEvent) {
//        let p = event.locationInWindow
//        currentPoint = self.convert(p, from: nil)
//        self.autoscroll(with: event)
//        self.needsDisplay = true
//        NSLog("mouseDragged: %@", NSStringFromPoint(p))
//    }
    
    override func mouseUp(with event: NSEvent) {
        NSLog("mouseUp")
        let p = event.locationInWindow
        currentPoint = self.convert(p, from: nil)
        self.needsDisplay = true
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

