//
//  Document.swift
//  ZIPspector
//
//  Created by 布川祐人 on 2018/05/27.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class Document: NSDocument, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    
    var filenames = [String]()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return NSNib.Name("Document")
    }

    override func read(from url: URL, ofType typeName: String) throws {
        let filename = url.path
        let task = Process()
        task.launchPath = "/usr/bin/zipinfo"
        let args : [String] = ["-1", filename]
        task.arguments = args
        
        let outPipe = Pipe()
        task.standardOutput = outPipe
        
        task.launch()
        
        let data = outPipe.fileHandleForReading.readDataToEndOfFile()
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        if status != 0 {
            let eDict = [NSLocalizedFailureErrorKey:"zipinfo failed"]
            throw NSError(domain: NSOSStatusErrorDomain, code: 0, userInfo: eDict)
        }
        
        let aString = String(data:data, encoding: .utf8)
        
        filenames = (aString?.components(separatedBy: CharacterSet.newlines))!
        
        //tableView?.reloadData()        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filenames.count
    }
    
    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any? {
        return filenames[row]
    }


}

