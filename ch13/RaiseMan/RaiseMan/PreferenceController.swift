//
//  PreferenceController.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/01/13.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class PreferenceController: NSWindowController {
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var checkBox: NSButton!

    static let BNRTableBgColorKey = "BNRTableBackgroundColor"
    static let BNREmptyDocKey = "BNREmptyDocumentFlag"
    
    override var windowNibName : NSNib.Name {
        return NSNib.Name("PreferenceController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
 
    @IBAction func changeBackgroundColor(_ sender : Any) {
        let color = colorWell.color
        NSLog("Color changed : %@", color)
    }
    
    @IBAction func changeNewEmptyDoc(_ sender : Any) {
        let state = checkBox.state
        NSLog("Checkbox changed %ld", state.rawValue)
    }
}
