//
//  RandomController.swift
//  Random
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class RandomController: NSObject {

    @IBOutlet weak var textField: NSTextField!
    
    @IBAction func seed(_ sender: Any) {
        arc4random_stir();
    }
    
    @IBAction func generate(_ sender: Any) {
//        let generated = (arc4random() % 100) + 1
        //        textField.stringValue = String(generated)
        let generated = arc4random_uniform(100) + 1
        textField.stringValue = String(generated)
    }
    
    override func awakeFromNib() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")
        //formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        textField.stringValue = formatter.string(from: now)
    }
    
}
