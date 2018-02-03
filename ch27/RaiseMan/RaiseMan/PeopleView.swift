//
//  PeopleView.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/02/03.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class PeopleView: NSView {

    var people : [Person] = []
    var attributes : [NSAttributedStringKey:Any] = [:]
    
    var lineHeight : CGFloat = 0
    var pageRect : NSRect = NSZeroRect
    var linesPerPage : Int = 0
    var currentPage : Int = 0
    
    init(withPeople lst : [Person]) {
        super.init(frame: NSMakeRect(0, 0, 700, 700))
        
        people = lst
        let font = NSFont(name: "Monaco", size: 12)
        lineHeight = (font?.capHeight)! * 1.7
        attributes[NSAttributedStringKey.font] = font
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        // fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Pagination
    
    override func knowsPageRange(_ range: NSRangePointer) -> Bool {
        let po = NSPrintOperation.current
        
        guard let printInfo = po?.printInfo else {
            return false
        }
        
        pageRect = printInfo.imageablePageBounds
        var newFrame = NSRect()
        newFrame.origin = NSZeroPoint
        newFrame.size = printInfo.paperSize
        self.frame = newFrame
        
        // ページの行数
        linesPerPage = (Int)(pageRect.size.height / lineHeight)
        
        // ページ番号は1から
        range.pointee.location = 1

        // 何ページ必要か
        range.pointee.length = people.count / linesPerPage
        if people.count % linesPerPage != 0 {
            range.pointee.length = range.pointee.length + 1
        }
        
        return true
    }
    
    override func rectForPage(_ page: Int) -> NSRect {
        currentPage = page - 1
        return pageRect
    }
    
    // MARK: - Drawing
    override var isFlipped: Bool {
        get {
            return true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var nameRect = NSRect()
        var raiseRect = NSRect()
        
        raiseRect.size.height = lineHeight
        nameRect.size.height = lineHeight
        
        nameRect.origin.x = pageRect.origin.x
        nameRect.size.width = 200
        raiseRect.origin.x = max(nameRect.origin.x, raiseRect.origin.x)
        raiseRect.size.width = 100
        
        for i in 0..<linesPerPage {
            let index = (currentPage * linesPerPage) + i
            if index >= people.count {
                break
            }
            
            let p = people[index]
            
            nameRect.origin.y = pageRect.origin.y + CGFloat(i) * lineHeight
            let nameString = NSString.init(format: "%2d %@", index, p.personName)
            nameString.draw(in: nameRect, withAttributes: attributes)

            raiseRect.origin.y = nameRect.origin.y
            let raiseString = NSString(format:"%4.1f%%", p.expectedRaise * 100)
            raiseString.draw(in:raiseRect, withAttributes:attributes)
        }
    }
    

}
