//
//  Document.swift
//  RaiseMan
//
//  Created by 布川祐人 on 2018/01/07.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    @objc
    var employees : [Person]
    
    override init() {
        employees = []
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

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
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
        employees.remove(at: index)
    }
}

