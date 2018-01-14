//
//  Document.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/01/07.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

private var kViewControllerContext: UInt8 = 0

class Document: NSDocument {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var employeeController: NSArrayController!

    @objc
    var employees : [Person] {
        willSet {
            for p:Person in employees {
                self.stopObservingPerson(p)
            }
        }
        didSet {
            for p:Person in employees {
                self.startObservingPerson(p)
            }
        }
    }
    
    override init() {
        employees = []
        super.init()
        // Add your subclass-specific initialization here.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleColorChange),
            name: NSNotification.Name(rawValue: PreferenceController.BNRColorChangedNotification),
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return NSNib.Name("Document")
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        //throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        
        tableView.window?.endEditing(for: nil)
        
        return NSKeyedArchiver.archivedData(withRootObject:employees)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        //throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        
        NSLog("About to read data of type %@", typeName)
        
        let newArray : [Person] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Person]
            
        self.employees = newArray
    }

    @objc dynamic
    func insertObject(_ employee : Person, inEmployeesAtIndex index: Int) {
        let undo = self.undoManager!
        
        undo.registerUndo(withTarget: self) { targetSelf in
            targetSelf.removeObjectFromEmployeesAtIndex(index)
        }
        
        if !undo.isUndoing {
            undo.setActionName("Add Person")
        }

        startObservingPerson(employee)
        employees.insert(employee, at: index)
    }
    
    @objc dynamic
    func removeObjectFromEmployeesAtIndex(_ index: Int) {
        let person : Person = employees[index]
        let undo = self.undoManager!
        
        undo.registerUndo(withTarget: self) { targetSelf in
            targetSelf.insertObject(person, inEmployeesAtIndex: index)
        }
        
        if !undo.isUndoing {
            undo.setActionName("Remove Person")
        }
        
        stopObservingPerson(person)
        employees.remove(at: index)
    }
    
    func startObservingPerson(_ p : Person) {
        p.addObserver(self,
                      forKeyPath: "personName",
                      options: NSKeyValueObservingOptions.old,
                      context: &kViewControllerContext)

        p.addObserver(self,
                      forKeyPath: "expectedRaise",
                      options: NSKeyValueObservingOptions.old,
                      context: &kViewControllerContext)
    }

    func stopObservingPerson(_ p : Person) {
        p.removeObserver(self, forKeyPath: "personName")
        p.removeObserver(self, forKeyPath: "expectedRaise")
    }
    
    func changeKeyPath(keyPath:String,
                       ofObject obj:AnyObject,
                       toValue newValue:AnyObject) {
        obj.setValue(newValue, forKeyPath:keyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context != &kViewControllerContext {
            // コンテキストが一致しない場合、このメッセージは
            // スーパークラスに宛てたものと判断される
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        guard let undo = self.undoManager else {
            return
        }
        
        let oldValue = change?[.oldKey]
        
        undo.registerUndo(withTarget: self) { (targetSelf) in
            targetSelf.changeKeyPath(keyPath:keyPath!,
                                     ofObject:object as AnyObject,
                                     toValue:oldValue as AnyObject)
        }
        
        undo.setActionName("Edit")
    }
    
    @IBAction func createEmployee(_ sender : Any) {
        guard let w = tableView.window else {
            return
        }
        
        let editingEnded = w.makeFirstResponder(w)
        if !editingEnded {
            NSLog("Unable to end editing")
            return
        }
        
        guard let undo = self.undoManager else {
            return
        }
        
        // このイベントの中ですでに編集が発生しているか
        if undo.groupingLevel > 0 {
            undo.endUndoGrouping()
            undo.beginUndoGrouping()
        }
        
        // オブジェクトを作成する
        let p = employeeController.newObject() as! Person
        
        // employeeControllerのコンテンツ配列に追加する
        employeeController.addObject(p)
        
        // 再度並べ替える (ユーザー列の並べ替えをした際に備えて)
        employeeController.rearrangeObjects()
        
        // 並べ替えられた配列を取得する
        let a = employeeController.arrangedObjects as! [Person]
        
        // 追加されたオブジェクトを検索する
        if let row = a.index(of: p) {
            NSLog("starting edit of %@ in row %lu", p, row)
            tableView.editColumn(0, row: row, with: nil, select: true)
        }
    }
    
    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        super.windowControllerDidLoadNib(windowController)
        tableView.backgroundColor = PreferenceController.preferenceTableBgColor
    }

    @objc
    func handleColorChange(_ note:NSNotification) {
        NSLog("Received notification: %@", note)
        
        guard let userInfo = note.userInfo else {
            return
        }
        
        guard let obj = userInfo["color"] else {
            return
        }
        
        let color = obj as! NSColor
        tableView.backgroundColor = color
    }
    
    @IBAction func removeEmployee(_ sender : Any) {
        let selectedPeople = employeeController.selectedObjects
        guard let count = selectedPeople?.count else {
            return
        }
        
        let alert = NSAlert()
        alert.messageText = "Do you really wany to remove these people?"
        alert.addButton(withTitle: "Remove")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = String(format:"%d people will be removed", count)
        alert.beginSheetModal(for: tableView.window!) { (response) -> Void in
            NSLog("Alert sheet ended")
            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
                self.employeeController.remove(nil)
            }
        }
    }
}

