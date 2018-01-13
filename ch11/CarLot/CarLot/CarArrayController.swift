//
//  CarArrayController.swift
//  CarLot
//
//  Created by 布川祐人 on 2018/01/13.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController {
    @IBOutlet weak var tableView: NSTableView!
    
    override func newObject() -> Any {
        let newObj = super.newObject() as AnyObject
        let now = NSDate()
        newObj.setValue(now, forKey: "datePurchased")
        
        return newObj
    }
    
    override func insert(_ object: Any, atArrangedObjectIndex index: Int) {
        super.insert(object, atArrangedObjectIndex: index)
        rearrangeObjects()
        let a = self.arrangedObjects as! [Car]
        
        if let row = a.index(of: object as! Car) {
            tableView.editColumn(0, row: row, with: nil, select: true)
        }
    }
}
