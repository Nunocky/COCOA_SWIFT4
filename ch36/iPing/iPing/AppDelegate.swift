//
//  AppDelegate.swift
//  iPing
//
//  Created by 布川祐人 on 2018/05/28.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var hostField: NSTextField!
    @IBOutlet var outputView: NSTextView!
    @IBOutlet weak var startButton: NSButton!
    
    var task : Process!
    var pipe : Pipe!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func startStopPing(_ sender: Any) {
        if task != nil {
            task.interrupt()
        }
        else {
            task = Process()
            task.launchPath = "/sbin/ping"
            task.arguments = ["-c10", hostField.stringValue]
            
            pipe = Pipe()
            task.standardOutput = pipe
            
            let fh = pipe.fileHandleForReading
            
            let nc = NotificationCenter.default
            nc.removeObserver(self)
            nc.addObserver(self,
                           selector: #selector(dataReady),
                           name: FileHandle.readCompletionNotification,
                           object: fh)
            
            nc.addObserver(self,
                           selector: #selector(taskTerminated),
                           name: Process.didTerminateNotification,
                           object: task)
            task.launch()
            outputView.string = ""
            
            fh.readInBackgroundAndNotify()
        }
    }
    
    private func appendData(_ d : Data) {
        if let s = String(data: d, encoding: String.Encoding.utf8), let ts = outputView.textStorage {
            let range = NSMakeRange(ts.length, 0)
            ts.replaceCharacters(in: range, with: s)
        }
    }
    
    @objc
    func dataReady(n: Notification) {
        if let userInfo = n.userInfo, let d = userInfo[NSFileHandleNotificationDataItem], d is Data {
            appendData(d as! Data)
        }
        
        if task != nil {
            pipe.fileHandleForReading.readInBackgroundAndNotify()
        }
    }
    
    @objc
    func taskTerminated(n: Notification) {
        task = nil
        startButton.state = NSControl.StateValue.off
    }

}

