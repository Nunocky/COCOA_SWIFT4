//
//  AppController.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/01/13.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class AppController: NSObject {
    @IBOutlet var window : NSWindow?  // これで warningは出なくなるのだけど正しいのか不明
    
    var preferenceController : PreferenceController? = nil
    
    override init() {
        var defaultValues : [String:Any] = [:]
        
        let colorAsData = NSKeyedArchiver.archivedData(withRootObject: NSColor.yellow)
        defaultValues[PreferenceController.BNRTableBgColorKey] = colorAsData
        defaultValues[PreferenceController.BNREmptyDocKey] = true
        
        UserDefaults.standard.register(defaults: defaultValues)
        NSLog("registered defaults : %@", defaultValues)
    }
    
    @IBAction func showPreferenceController(_ sender : Any) {
        if preferenceController == nil {
            preferenceController = PreferenceController()
        }
        
        preferenceController?.showWindow(self)
    }
    
    @IBAction func showAboutPanel(_ sender : Any) {
        _ = Bundle.main.loadNibNamed(NSNib.Name("AboutPanel"), owner: self, topLevelObjects: nil)
    }
    
    @objc
    func applicationShouldOpenUntitledFile(_ sender : NSApplication) -> Bool {
        return PreferenceController.preferenceEmptyDoc
    }
    
    @objc
    func applicationWillResignActive(_ notification: Notification) {
        NSLog("applicationWillResignActive")
    }
    
    @objc
    func applicationDidResignActive(_ notification: Notification) {
        NSLog("applicationDidResignActive")
        NSSound.beep()
    }
    
    @objc
    func applicationDidBecomeActive(_ notification: Notification) {
        NSLog("applicationDidBecomeActive")
    }
    
}
