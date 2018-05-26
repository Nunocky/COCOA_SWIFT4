//
//  ColorFormatter.swift
//  TypingTutor
//
//  Created by 布川祐人 on 2018/05/26.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class ColorFormatter: Formatter {
    let colorList = NSColorList(named: NSColorList.Name("Apple"))!
    
    func firstColorKeyForPartialString(_ string: String) -> String? {
        if string.count == 0 {
            return nil
        }
        
        for k in colorList.allKeys {
            let key = k.rawValue
            if let whereFound = key.range(of: string, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) {
                let range = NSRange(whereFound, in:string)
                if range.location == 0 && range.length > 0 {
                    return key
                }
            }
        }
        
        return nil
    }
    
    override func string(for obj: Any?) -> String? {
        if obj == nil {
            return nil
        }
        
        if let object = obj as? NSColor {
            let color = object.usingColorSpaceName(NSColorSpaceName.calibratedRGB)!
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: nil)
            
            var minDistance : CGFloat = 3.0
            var closestKey : String? = nil
            for k in colorList.allKeys {
                let key = k.rawValue
                let c = colorList.color(withKey: k)!
                var r: CGFloat = 0
                var g: CGFloat = 0
                var b: CGFloat = 0
                c.getRed(&r, green: &g, blue: &b, alpha: nil)
                let dist = pow(red-r, 2) + pow(green-g, 2) + pow(blue-b, 2)
                
                if dist < minDistance {
                    minDistance = dist
                    closestKey = key
                }
            }
            return closestKey
        }
        
        return nil
    }
    
    override func attributedString(for obj: Any,
                                   withDefaultAttributes attrs: [NSAttributedStringKey : Any]? = nil) -> NSAttributedString? {
        if let match = string(for: obj) {
            var attDict = attrs ?? [:]
            attDict[.foregroundColor] = obj
            return NSAttributedString(string: match, attributes: attDict)
        }
        
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if let matchingKey = firstColorKeyForPartialString(string) {
            obj?.pointee = colorList.color(withKey: NSColor.Name(matchingKey))
            return true
        }

        error?.pointee = (string + " is not a color") as NSString
        return false
    }

//    override func isPartialStringValid(_ partialString: String,
//                                       newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
//                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
//        if partialString.count == 0 {
//            return true
//        }
//
//        if firstColorKeyForPartialString(partialString) != nil {
//            return true
//        }
//
//        error?.pointee = "No such Color" as NSString
//        return false
//    }
    
    override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
                                       proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
                                       originalString origString: String,
                                       originalSelectedRange origSelRange: NSRange,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if partialStringPtr.pointee.length == 0 {
            return true
        }
        if let match = firstColorKeyForPartialString(partialStringPtr.pointee as String) {
            if origSelRange.location == proposedSelRangePtr?.pointee.location {
                return true
            }
            
            if match.count != partialStringPtr.pointee.length {
                proposedSelRangePtr?.pointee.location = partialStringPtr.pointee.length
                proposedSelRangePtr?.pointee.length = match.count - (proposedSelRangePtr?.pointee.location)!
                partialStringPtr.pointee = match as NSString
                return false
            }
            
            return true
        }

        return false
    }
}
