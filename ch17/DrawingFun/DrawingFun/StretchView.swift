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
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//    }
    
    required init?(coder decoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        path = NSBezierPath()
        
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
    }

    func randomPoint() -> NSPoint {
        var result = NSPoint()
        let r = self.bounds
        
        result.x = r.origin.x + (CGFloat)(arc4random() % (UInt32)(r.size.width))
        result.y = r.origin.y + (CGFloat)(arc4random() % (UInt32)(r.size.height))
        return result
    }
}
