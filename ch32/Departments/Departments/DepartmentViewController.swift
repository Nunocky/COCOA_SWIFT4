//
//  DepartmentViewController.swift
//  Departments
//
//  Created by 布川祐人 on 2018/02/04.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class DepartmentViewController: ManagingViewController {

//    init() {
//        super.init()
//        self.title = "Departments"
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.title = "Departments"
//    }

    required init?(coder : NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    convenience init() {
        self.init(nibName: NSNib.Name("DepartmentView"), bundle: nil)
    }
    
    func setup() {
            self.title = "Departments"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
