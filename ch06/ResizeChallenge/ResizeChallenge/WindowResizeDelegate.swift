//
//  WindowResizeDelegate.swift
//  ResizeChallenge
//
//  Created by 布川祐人 on 2018/01/06.
//  Copyright © 2018年 NUNOKAWA Masato. All rights reserved.
//

import Cocoa

class WindowResizeDelegate: NSObject, NSWindowDelegate {

    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        var newSize = frameSize
        newSize.width = newSize.height * 2
        return newSize
    }

}
