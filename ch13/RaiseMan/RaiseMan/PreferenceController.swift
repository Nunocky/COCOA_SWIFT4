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

    static var preferenceTableBgColor : NSColor {
        get {
            let defaults = UserDefaults.standard
            let colorAsData = defaults.object(forKey: PreferenceController.BNRTableBgColorKey) as! Data

            return NSKeyedUnarchiver.unarchiveObject(with: colorAsData) as! NSColor
        }
        
        set {
            let defaults = UserDefaults.standard
            let colorAsData = NSKeyedArchiver.archivedData(withRootObject: newValue)
            defaults.setValue(colorAsData, forKey: PreferenceController.BNRTableBgColorKey)
        }
    }
    
    static var preferenceEmptyDoc: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: PreferenceController.BNREmptyDocKey)
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: PreferenceController.BNREmptyDocKey)
        }
    }
    
    override var windowNibName : NSNib.Name {
        return NSNib.Name("PreferenceController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        colorWell.color = PreferenceController.preferenceTableBgColor
        checkBox.state = (PreferenceController.preferenceEmptyDoc) ? .on : .off
    }
 
    @IBAction func changeBackgroundColor(_ sender : Any) {
        let color = colorWell.color
        PreferenceController.preferenceTableBgColor = color
        NSLog("Color changed : %@", color)
    }
    
    @IBAction func changeNewEmptyDoc(_ sender : Any) {
        let state = checkBox.state
        PreferenceController.preferenceEmptyDoc = (state == .on)
        NSLog("Checkbox changed %ld", state.rawValue)
    }
}
