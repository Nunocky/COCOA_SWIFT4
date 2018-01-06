//
//  AppDelegate.swift
//  TodoChallenge
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textField: NSTextField!
    
    var lines : [String] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        lines.append(textField.stringValue)
        tableView.reloadData()
    }
    
    // MARK :- NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return lines[row]
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        //NSLog("update %d", row)
        let newValue = object as! String

        if newValue.count == 0 {
            lines.remove(at: row)
        } else {
            lines[row] = newValue
        }
        tableView.reloadData()
    }
}

