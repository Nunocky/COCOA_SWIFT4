//
//  CarArrayController.swift
//  CarLot
//
//  Created by 布川祐人 on 2018/01/13.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController {
    override func newObject() -> Any {
        let newObj = super.newObject() as AnyObject
        let now = NSDate()
        newObj.setValue(now, forKey: "datePurchased")
        
        return newObj
    }
}
