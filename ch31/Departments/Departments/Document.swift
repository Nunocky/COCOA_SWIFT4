//
//  Document.swift
//  Departments
//
//  Created by 布川祐人 on 2018/02/04.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

// ref: Swift で UIViewController のサブクラスを引数なしの -init でインスタンス化する
//      https://qiita.com/shota_hamada/items/f6bf6d2700b2cd8369b8

import Cocoa

class Document: NSPersistentDocument {

    
    @IBOutlet weak var box: NSBox!
    @IBOutlet weak var popUp: NSPopUpButton!
    var viewControllers : [ManagingViewController] = []
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        
        let vc = DepartmentViewController()
        vc.managedObjectContext = self.managedObjectContext
        viewControllers.append(vc)
        
        let vc2 = EmployeeViewController()
        vc2.managedObjectContext = self.managedObjectContext
        viewControllers.append(vc2)
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return NSNib.Name("Document")
    }

    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        let menu = popUp.menu
        let itemCount = viewControllers.count
        
        for i in 0..<itemCount {
            let vc = viewControllers[i]
            let mi = NSMenuItem(title: vc.title!,
                                action: #selector(changeViewController(_:)),
                                keyEquivalent: "")
            mi.tag = i
            menu?.addItem(mi)
            
            // 最初のコントローラを表示
            self.displayViewController(viewControllers[0])
            popUp.selectItem(at: 0)
        }
    }
    
    @IBAction func changeViewController(_ sender : Any) {

        let item = sender as! NSMenuItem
        
        let i = item.tag
        let vc = viewControllers[i]
        
        displayViewController(vc)
    }
    
    func displayViewController(_ vc : ManagingViewController) {
        let w = box.window
        let ended = w?.makeFirstResponder(w)
        if !ended! {
            NSSound.beep()
            return
        }
        
        let v = vc.view
        box.contentView = v
    }
}
