//
//  NSString+FirstLetter.swift
//  TypingTutor
//
//  Created by 布川祐人 on 2018/01/27.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Foundation


extension NSString {
    func bnr_firstLetter() -> NSString {
        if self.length < 2 {
            return self
        }
        
        var r = NSRange()
        r.location = 0
        r.length = 1
        let subStr = self.substring(with: r)
        
        return NSString(string:subStr)
    }
}
