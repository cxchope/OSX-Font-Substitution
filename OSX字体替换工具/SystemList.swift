//
//  SystemList.swift
//  OSX字体替换工具
//
//  Created by 神楽坂雅詩 on 14/8/23.
//  Copyright (c) 2014年 神楽坂雅詩. All rights reserved.
//

import Cocoa

class SystemList: NSObject {
    
    let 系统支持列表:NSArray = [
        "Version 10.10 (Build 14A329f)"
    ]
    
    func 系统是否支持() -> Bool
    {
        let 系统版本号字符串:NSString = NSProcessInfo.processInfo().operatingSystemVersionString
        print("💻 ")
        println(系统版本号字符串)
        var 是否支持:Bool = false
        for 当前版本号 in 系统支持列表 {
            let 当前版本字符串:NSString = 当前版本号 as NSString
            if (当前版本字符串.isEqualToString(系统版本号字符串)) {
                是否支持 = true
                break
            }
        }
        return 是否支持
    }
    
}
