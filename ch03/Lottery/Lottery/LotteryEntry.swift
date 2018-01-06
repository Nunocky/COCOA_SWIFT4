//
//  LotteryEntry.swift
//  Lottery
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class LotteryEntry: NSObject {

    var firstNumber : Int // = 0
    var secondNumber : Int // = 0
    var entryDate : Date // = Date()

    override init() {
        firstNumber = Int(arc4random_uniform(100) + 1)
        secondNumber = Int(arc4random_uniform(100) + 1)
        entryDate = Date()
    }

    convenience init(withEntryDate date: Date) {
        self.init()
        entryDate = date
    }
    
//    func prepareRandomNumbers() {
//        firstNumber = Int(arc4random_uniform(100) + 1)
//        secondNumber = Int(arc4random_uniform(100) + 1)
//    }

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
