//
//  Person.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/01/07.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@objc(Person)
class Person: NSObject, NSCoding {

    @objc
    var personName : String
    
    @objc
    var expectedRaise : Float
    
    override init() {
        personName = "New Person"
        expectedRaise = 0.05
    }
    
    required init(coder : NSCoder) {
        personName = coder.decodeObject(forKey: "personName") as! String
        expectedRaise = coder.decodeFloat(forKey: "expectedRaise")
        super.init()
    }
    
//    required init?(coder aDecoder:NSCoder) {
//        self.personName = aDecoder.decodeObject(forKey: "personName") as! String
//        self.expectedRaise = aDecoder.decodeFloat(forKey: "expectedRaise")
//    }
    
    func encode(with coder:NSCoder) {
        coder.encode(personName, forKey: "personName")
        coder.encode(expectedRaise, forKey: "expectedRaise")
    }

    override func setNilValueForKey(_ key: String) {
        if key == "expectedRaise" {
            expectedRaise = 0
        } else {
            super.setNilValueForKey(key)
        }
    }
    
    
    
}
