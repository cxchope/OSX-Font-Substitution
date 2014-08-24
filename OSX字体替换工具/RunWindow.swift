//
//  RunWindow.swift
//  OSX字体替换工具
//
//  Created by 神楽坂雅詩 on 14/8/24.
//  Copyright (c) 2014年 神楽坂雅詩. All rights reserved.
//

import Cocoa

class RunWindow: NSView {

    var 初始化完毕:Bool = false
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if (!初始化完毕) {
//            self.window?.styleMask = NSFullScreenWindowMask
            let 全屏尺寸:CGRect = NSScreen.mainScreen().frame
            self.frame = 全屏尺寸
            初始化完毕 = true
        }
        // Drawing code here.
    }
    
}
