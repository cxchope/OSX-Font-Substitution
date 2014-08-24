//
//  ChangeData.swift
//  OSX字体替换工具
//
//  Created by 神楽坂雅詩 on 14/8/24.
//  Copyright (c) 2014年 神楽坂雅詩. All rights reserved.
//

import Cocoa

class ChangeData: NSObject {
    
    var 改为项目显示:NSString = ""
    var 改为项目值:NSString = ""
    var 改为字体显示:NSString = ""
    var 改为字体值:NSString = ""
    var 改为语言显示:NSString = ""
    var 改为语言值:NSString = ""
    var 数据:NSDictionary = NSDictionary.dictionary()
    
    func 开始处理操作() -> NSDictionary
    {
        var 改为显示:NSString = NSString(format: "将处于%@时的%@改为%@字体…",改为语言显示,改为项目显示,改为字体显示)
        println(改为显示)
        println("🔵 读节点 /root/ (DIC)")
        let r_Root_keys:NSArray = 数据.allKeys
        var 新数据:NSMutableDictionary = NSMutableDictionary.dictionary()
        for r_Root_key_now_obj in r_Root_keys {
            let r_Root_key_now:NSString = r_Root_key_now_obj as NSString
            println("🔵 读节点 /root/\(r_Root_key_now)/ (ARR)")
            let r_root_arr_now:NSArray = 数据.objectForKey(r_Root_key_now) as NSArray
            var w_root_arr_now:NSMutableArray = NSMutableArray.array()
            for r_now_item in r_root_arr_now {
                if (r_now_item is NSArray) {
                    let r_now_item_arr:NSArray = r_now_item as NSArray
                    println("🔵 读节点 /root/\(r_Root_key_now)/<Array>/ (ARR)")
                    let r_now_item_arr_arr:NSArray = r_now_item_arr as NSArray
                    println("🔵 读节点 /root/\(r_Root_key_now)/<Array>/<Array>/ (ARR)")
                    var w_now_item_arr_arr:NSMutableArray = NSMutableArray.array()
                    for r_语言数组对象 in r_now_item_arr_arr {
                        let r_语言数组:NSArray = r_语言数组对象 as NSArray
                        let r_语言:NSString = r_语言数组.objectAtIndex(0) as NSString
                        println("🔵 读数据 /root/\(r_Root_key_now)/<Array>/<Array>/\(r_语言) (STR)")
                        let r_语言对应字体:NSString = r_语言数组.objectAtIndex(1) as NSString
                        println("🔵 读数据 /root/\(r_Root_key_now)/<Array>/<Array>/\(r_语言对应字体) (STR)")
                        println("🔴 写数据 /root/\(r_Root_key_now)/<Array>/<Array>/\(r_语言) (STR)")
                        let w_语言数组:NSMutableArray = [r_语言]
                        if ((改为项目值.isEqualToString(r_Root_key_now) || 改为项目值.isEqualToString("all")) && (r_语言.isEqualToString(改为语言值) || 改为语言值.isEqualToString("all"))) {
                            println("🔶 替换数据：\(r_语言对应字体) ▶️ \(改为字体值)")
                            println("🔴 写数据 /root/\(r_Root_key_now)/<Array>/<Array>/\(改为字体值) (STR)")
                            w_语言数组.addObject(改为字体值)
                        } else {
                            println("🔴 写数据 /root/\(r_Root_key_now)/<Array>/<Array>/\(r_语言对应字体) (STR)")
                            w_语言数组.addObject(r_语言对应字体)
                        }
                        println("🔴 写节点 /root/\(r_Root_key_now)/<Array>/<Array>/ (ARR)")
                        w_now_item_arr_arr.addObject(w_语言数组)
                    }
                    println("🔴 写节点 /root/\(r_Root_key_now)/<Array>/ (ARR)")
                    w_root_arr_now.addObject(w_now_item_arr_arr)
                } else {
                    println("🔵 读数据 /root/\(r_Root_key_now)/\(r_now_item) (STR)")
                    println("🔴 写数据 /root/\(r_Root_key_now)/\(r_now_item) (STR)")
                    w_root_arr_now.addObject(r_now_item)
                }
            }
            println("🔴 写节点 /root/\(r_Root_key_now) (DIC)")
            新数据.setObject(w_root_arr_now, forKey: r_Root_key_now)
        }
        println("🔴 写节点 /root/ (DIC)")
        return 新数据
    }
}

