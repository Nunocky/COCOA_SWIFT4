//
//  AppDelegate.swift
//  Scattered
//
//  Created by NUNOKAWA Masato on 2018/04/27.
//  Copyright © 2018年 Masato NUNOKAWA. All rights reserved.
//

import Cocoa
import QuartzCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var view: NSView!
    
    var processingQueue = OperationQueue()
    var textLayer : CATextLayer!

    override init() {
        super.init()
        processingQueue.maxConcurrentOperationCount = 4
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        arc4random_stir()

        view.layer = CALayer()
        view.wantsLayer = true
        
        let textContainer = CALayer()
        textContainer.anchorPoint = CGPoint.zero
        textContainer.position = CGPoint(x: 10, y: 10)
        textContainer.zPosition = 100
        textContainer.backgroundColor = CGColor.black
        textContainer.borderColor = CGColor.white
        textContainer.borderWidth = 2
        textContainer.cornerRadius = 15
        textContainer.shadowOpacity = 0.5
        view.layer?.addSublayer(textContainer)
        
        textLayer = CATextLayer()
        textLayer?.anchorPoint = CGPoint.zero
        textLayer?.position = CGPoint(x: 10, y: 6)
        textLayer?.zPosition = 100
        textLayer?.fontSize = 24
        textLayer?.foregroundColor = CGColor.white
        textContainer.addSublayer(textLayer!)
        
        //self.setText("Loading...")
        text = "Loading..."
        
        self.addImagesFromFolderURL(URL(fileURLWithPath: "/Library/Desktop Pictures"))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    var text : String? {
        didSet {
            let font = NSFont.systemFont(ofSize: textLayer!.fontSize)
            let attrs = [NSAttributedStringKey.font : font]
            var size = text?.size(withAttributes: attrs) ?? CGSize.zero

            // サイズが整数であることを確認する
            size.width = ceil(size.width)
            size.height = ceil(size.height)
            textLayer?.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            textLayer?.superlayer?.bounds = CGRect(x: 0, y: 0, width: size.width + 16, height: size.height + 20)
            textLayer?.string = text
        }
    }
    
    func thumbImageFromImage(_ image : NSImage) -> NSImage {
        let targetHeight : CGFloat = 200.0
        let imageSize = image.size
        let smallerSize = NSSize(width: targetHeight * imageSize.width / imageSize.height, height: targetHeight)
        
        let smallerImage = NSImage(size: smallerSize)
        smallerImage.lockFocus()

        image.draw(in: NSRect(x: 0, y: 0, width: smallerSize.width, height: smallerSize.height), from: NSRect.zero, operation: NSCompositingOperation.copy, fraction: 1.0)
        
        smallerImage.unlockFocus()
        return smallerImage
    }

    func addImagesFromFolderURL(_ folderURL: URL) {
        
        processingQueue.addOperation {
            let t0 = NSDate.timeIntervalSinceReferenceDate
            let fileManager = FileManager()

            let dirEnum = fileManager.enumerator(at: folderURL,
                                                 includingPropertiesForKeys: nil,
                                                 options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
                                                 errorHandler: nil)
            
            while let url = dirEnum?.nextObject() as? NSURL {
                var isDirectoryValue : AnyObject?
                
                do {
                    try url.getResourceValue(&isDirectoryValue, forKey: URLResourceKey.isDirectoryKey)
                }
                catch let error as NSError {
                    NSLog("%s", error)
                    continue
                }
                
                guard let isDirectory = isDirectoryValue as? Bool else {
                    continue
                }
                
                if isDirectory == true {
                    continue
                }
              
                self.processingQueue.addOperation {
                    guard let image = NSImage(contentsOf: url as URL) else {
                        return
                    }

                    let thumbImage = self.thumbImageFromImage(image)

                    OperationQueue.main.addOperation {
                        self.presentImage(thumbImage)
                        let t1 = NSDate.timeIntervalSinceReferenceDate
                        self.text = String(format: "%0.1fs", t1 - t0)
                    }
                }
            }
        }
    }

    func presentImage(_ image : NSImage) {
        let superlayerBounds = view.layer!.bounds

        let center = CGPoint(x: superlayerBounds.midX, y: superlayerBounds.midY)

        let imageBounds = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        let randomPoint = CGPoint(x: superlayerBounds.maxX * CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
                                  y: superlayerBounds.maxY * CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
//        let randomPoint =
//            CGPoint(x: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxX))),
//                    y: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxY))))

        let tf = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        let posAnim = CABasicAnimation()
        posAnim.fromValue = NSValue(point: center)
        posAnim.duration = 1.5
        posAnim.timingFunction = tf

        let bdsAnim = CABasicAnimation()
        bdsAnim.fromValue = NSValue(point: NSPoint.zero)
        bdsAnim.duration = 1.5
        bdsAnim.timingFunction = tf

        let layer = CALayer()
        layer.contents = image
        layer.actions = [
            "position":posAnim,
            "bounds":bdsAnim]

        CATransaction.begin()
        view.layer!.addSublayer(layer)
        layer.position = randomPoint
        layer.bounds = imageBounds
        CATransaction.commit()
    }
}

