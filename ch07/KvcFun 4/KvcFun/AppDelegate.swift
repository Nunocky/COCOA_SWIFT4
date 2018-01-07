//
//  AppDelegate.swift
//  KvcFun
//
//  Created by 布川祐人 on 2018/01/07.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @objc
    var fido = 0

//    var fido_ = 0
//
//    @objc
//    var fido : Int {
//        get {
//            NSLog("getter is returning %d", fido_)
//            return fido_
//        }
//
//        set {
//            NSLog("setter is called with %d", newValue)
//            fido_ = newValue
//        }
//    }
    
    override init() {
        super.init()
        
        self.setValue(5, forKey: "fido")
        let num = self.value(forKey: "fido") as! NSNumber
        NSLog("%d", num.intValue)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    @IBAction func incrementFido(_ sender : Any) {

//        self.willChangeValue(forKey: "fido")
//        fido += 1
//        self.didChangeValue(forKey: "fido")
        
        let n = self.value(forKeyPath: "fido") as! NSNumber
        let npp = NSNumber.init(value: n.intValue + 1)
        self.setValue(npp, forKey: "fido")

        NSLog("fido is now %d", fido)
    }
}

