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
    
    @IBAction func showPreferenceController(_ sender : Any) {
        if preferenceController == nil {
            preferenceController = PreferenceController()
        }
        
        preferenceController?.showWindow(self)
    }
    
    @IBAction func showAboutPanel(_ sender : Any) {
        _ = Bundle.main.loadNibNamed(NSNib.Name("AboutPanel"), owner: self, topLevelObjects: nil)
    }
    
}
