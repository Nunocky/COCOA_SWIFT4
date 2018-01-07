//
//  Person.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/01/07.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@objc(Person)
class Person: NSObject {

    @objc
    var personName : String
    
    @objc
    var expectedRaise : Float
    
    override init() {
        personName = "New Person"
        expectedRaise = 0.05
    }
    
    override func setNilValueForKey(_ key: String) {
        if key == "expectedRaise" {
            expectedRaise = 0
        } else {
            super.setNilValueForKey(key)
        }
    }
}
