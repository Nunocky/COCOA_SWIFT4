//
//  Employee+fullName.swift
//  Departments
//
//  Created by 布川祐人 on 2018/05/30.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Foundation

extension Employee {
    @objc
    var fullName : String {
        get {
            if firstName == nil {
                return lastName!
            }
            
            if lastName == nil {
                return firstName!
            }
            
            return String("\(firstName!) \(lastName!)")
        }
    }

    @objc dynamic
    static var keyPathsForValuesAffectingFullName : Set<String> {
        get {
            return ["firstName", "lastName"]
        }
    }
}
