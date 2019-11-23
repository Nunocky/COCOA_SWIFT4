//
//  main.swift
//  Lottery
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Foundation

//var array : [Int] = []
//
//for i in 0..<10 {
//    array.append(i * 3)
//}
//
//for i in 0..<10 {
//    let num = array[i]
//    NSLog("The number at Index %d is %d", i, num)
//}

let now = Date()
let cal = NSCalendar.current
let weekComponents = NSDateComponents()

//乱数ジェネレータをシード
//arc4random_stir()

var array : [LotteryEntry] = []

for i in 0..<10 {
    weekComponents.weekday = i
    
    let iWeeksFromNow = cal.date(byAdding: weekComponents as DateComponents,
                                 to: now)

    // 0.
    //let newEntry = LotteryEntry()
    //newEntry.prepareRandomNumbers()
    //newEntry.entryDate = iWeeksFromNow!

    // 1.
    //let newEntry = LotteryEntry()
    //newEntry.entryDate = iWeeksFromNow!

    // 2.
    let newEntry = LotteryEntry(withEntryDate: iWeeksFromNow!)
    
    array.append(newEntry)
}

for ent in array {
    NSLog("%@", ent.description)
}
