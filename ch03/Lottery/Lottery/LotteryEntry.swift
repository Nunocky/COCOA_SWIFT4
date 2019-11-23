//
//  LotteryEntry.swift
//  Lottery
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class LotteryEntry: NSObject {

    var firstNumber : Int
    var secondNumber : Int
    var entryDate : Date

    override init() {
        firstNumber = Int.random(in:1...100)
        secondNumber = Int.random(in:1...100)
        entryDate = Date()
    }

    convenience init(withEntryDate date: Date) {
        self.init()
        entryDate = date
    }
    
    override var description: String {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .medium
        
        let result = String(format: "%@ = %d and %d",
                            df.string(from: entryDate),
                            firstNumber,
                            secondNumber)
        return result
    }
}
