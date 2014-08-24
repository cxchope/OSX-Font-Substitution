//
//  MainView.swift
//  OSX字体替换工具
//
//  Created by 神楽坂雅詩 on 14/8/23.
//  Copyright (c) 2014年 神楽坂雅詩. All rights reserved.
//

import Cocoa

class MainView: NSView, NSComboBoxDataSource, NSComboBoxDelegate, NSAlertDelegate, NSWindowDelegate {
    
    @IBOutlet weak var 项目选择: NSComboBox!
    @IBOutlet weak var 字体选择: NSComboBox!
    @IBOutlet weak var 大小选择: NSComboBox!
    @IBOutlet weak var 语言选择: NSComboBox!
//    @IBOutlet weak var 字体选择: NSButton!
//    @IBOutlet weak var 大小选择: NSButton!
    @IBOutlet weak var 确定按钮: NSButton!
    @IBOutlet weak var 取消按钮: NSButton!
    @IBOutlet weak var 示例图像: NSImageView!
    
    @IBOutlet weak var 还原按钮: NSButton!
    @IBOutlet weak var 关于按钮: NSButton!
    
    @IBOutlet weak var demo1: NSTextField!
    @IBOutlet weak var demo2: NSTextField!
    @IBOutlet weak var demo3: NSTextField!
    @IBOutlet weak var demo4: NSTextField!
    @IBOutlet weak var demo5: NSTextField!
    @IBOutlet weak var demo6: NSTextField!
    @IBOutlet weak var demo7: NSTextField!
    @IBOutlet weak var demo8: NSTextField!
    @IBOutlet weak var demo9: NSTextField!
    @IBOutlet weak var demo10: NSTextField!
    @IBOutlet weak var demo11: NSTextField!
    @IBOutlet weak var demo12: NSTextField!
    @IBOutlet weak var demo13: NSTextField!
    
    let 文件路径:NSString = "/System/Library/Frameworks/CoreText.framework/Versions/A/Resources/DefaultFontFallbacks.plist"
    let 备份文件路径:NSString = "/System/Library/Frameworks/CoreText.framework/Versions/A/Resources/DefaultFontFallbacks.plist.bak"
    var 已初始化:Bool = false
    var 已加载完成:Bool = false
    var 项目显示数组:NSMutableArray = NSMutableArray.array()
    var 字体显示数组:NSMutableArray = NSMutableArray.array()
    var 大小显示数组:NSMutableArray = ["OS X 默认大小","初号(42pt)","小初(36pt)","一号(26pt)","小一(24pt)","二号(22pt)","小二(18pt)","三号(16pt)","小三(15pt)","四号(14pt)","小四(12pt)","五号(10.5pt)","小五(9pt)","六号(7.5pt)","小六(6.5pt)","七号(5.5pt)","八号(5pt)"]
    var 语言显示数组:NSMutableArray = NSMutableArray.array()
    
    var 项目值数组:NSMutableArray = NSMutableArray.array()
    var 字体值数组:NSMutableArray = NSMutableArray.array()
    var 大小值数组:NSMutableArray = ["12","42","36","26","24","22","18","16","15","14","12","10.5","9","7.5","6.5","5.5","5"]
    var 语言值数组:NSMutableArray = NSMutableArray.array()
    
    let 文件管理:NSFileManager = NSFileManager()
    var 字体管理:NSFontManager = NSFontManager.sharedFontManager()
//    let 正在载入提示:NSTextField = NSTextField()
    var 数据字典:NSDictionary = NSDictionary.dictionary()
    var 数据字典备份:NSDictionary = NSDictionary.dictionary()
//    var 遮罩:NSView = NSView()
    @IBOutlet weak var 遮罩: NSTextField!
    
    
//    var 全局窗口
    
    var 旧项目选择:Int = 0
    var 旧字体选择:Int = 0
    var 旧大小选择:Int = 0
    var 旧语言选择:Int = 0
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if (!已初始化) {
            system("clear")
            println(＝＝＝)
            println("🔤 OS X 10.10 字体替换工具 v1.0.0")
            println("🎀 神楽坂雅詩 作品")
            println("🌍 http://uuu.moe")
            println(＝＝＝)
//            正在载入提示.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
//            正在载入提示.backgroundColor = NSColor.blackColor()
//            正在载入提示.textColor = NSColor.whiteColor()
//            正在载入提示.placeholderString = "12"
//            self.addSubview(正在载入提示)
            项目选择.tag = 100
//            项目选择.delegate = self
//            项目选择.dataSource = self
//            项目选择.reloadData()
            字体选择.tag = 101
//            字体选择.delegate = self
//            字体选择.dataSource = self
//            字体选择.reloadData()
            大小选择.tag = 102
//            大小选择.delegate = self
//            大小选择.dataSource = self
//            大小选择.reloadData()
            语言选择.tag = 103
            已初始化 = true
            系统版本检查()
            if (文件校验() && 载入数据() && 载入字体() && 载入语言()) {
                大小选择.reloadData()
                大小选择.selectItemAtIndex(0)
                if (权限验证()) {
                    还原按钮.enabled = true
                    确定按钮.enabled = true
                } else {
                    还原按钮.title = "请用启动器提权"
                    确定按钮.title = "请用启动器提权"
                }
                项目选择.enabled = true
                字体选择.enabled = true
                大小选择.enabled = true
                语言选择.enabled = true
                数据字典备份 = 数据字典
                println("🏁 程序初始化完成，等待操作～")
                println(－－－)
                已加载完成 = true
            }
            示例图像.layer?.shadowColor = NSColor.blackColor().CGColor
            示例图像.layer?.shadowOffset = CGSizeMake(2, 2)
            示例图像.layer?.shadowOpacity = 1.0
            示例图像.layer?.shadowRadius = 1.0
            self.window?.delegate = self
//            遮罩.layer?.backgroundColor = NSColor.blackColor().CGColor
//            遮罩.alphaValue = 0.5
//            self.addSubview(遮罩)
//            遮罩.hidden = true
            
//            正在载入提示.removeFromSuperview()
//            字体管理.delegate = self
        }
    }
//    @IBAction func 字体选择(sender: NSButton) {
//        let arr:NSArray = 字体管理.availableFonts
//        let arr2:NSArray = 字体管理.availableFontFamilies
//        println(arr)
//    }

//    @IBAction func 大小选择(sender: NSComboBox) {
//        字体管理.orderFrontFontPanel(self.layer)
//    }
    
    func windowShouldClose(sender: AnyObject!) -> Bool
    {
        println("✋ 不保存设置并退出")
        exit(0)
    }
    
    func 遮罩视图(开关:Bool)
    {
        if (开关) {
            遮罩.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            遮罩.hidden = false
        } else {
            遮罩.hidden = true
        }
    }
    
    func comboBoxSelectionDidChange(notification: NSNotification!)
    {
        if (已加载完成) {
            let 当前下拉框:NSComboBox = notification.object as NSComboBox
            switch (当前下拉框.tag) {
            case 100:
                if (当前下拉框.indexOfSelectedItem > 0 && 当前下拉框.indexOfSelectedItem < 1000)
                {
                    旧项目选择 = 当前下拉框.indexOfSelectedItem
                }
                读取当前项目字体()
                break
            case 101:
                if (当前下拉框.indexOfSelectedItem > 0 && 当前下拉框.indexOfSelectedItem < 1000)
                {
                    旧字体选择 = 当前下拉框.indexOfSelectedItem
                }
                写入配置()
                break
            case 102:
                if (当前下拉框.indexOfSelectedItem > 0 && 当前下拉框.indexOfSelectedItem < 1000)
                {
                    旧大小选择 = 当前下拉框.indexOfSelectedItem
                }
                当前下拉框.selectItemAtIndex(0)
                当前下拉框.enabled = false
                break
            case 103:
                if (当前下拉框.indexOfSelectedItem > 0 && 当前下拉框.indexOfSelectedItem < 1000)
                {
                    旧语言选择 = 当前下拉框.indexOfSelectedItem
                }
                读取当前项目字体()
                break
            default:
                break
            }
        }
    }
    
    func 读取当前项目字体()
    {
        匹配内存数据()
        println("⌛️ 读取当前项目字体...")
        var 项目选择当前选项:Int = 项目选择.indexOfSelectedItem
        var 语言选择当前选项:Int = 语言选择.indexOfSelectedItem
        let 当前项目显示:NSString = 项目显示数组.objectAtIndex(项目选择当前选项) as NSString
        let 当前项目值:NSString = 项目值数组.objectAtIndex(项目选择当前选项) as NSString
        let 当前语言显示:NSString = 语言显示数组.objectAtIndex(语言选择当前选项) as NSString
        let 当前语言值:NSString = 语言值数组.objectAtIndex(语言选择当前选项) as NSString
        let 全部KEY:NSArray = 数据字典.allKeys
        var 调出字体显示:NSString = ""
        var 调出字体值:NSString = ""
        for 当前KEY对象 in 全部KEY {
            let 当前KEY:NSString = 当前KEY对象 as NSString
            if (当前KEY.isEqualToString(当前项目值) || 当前项目值.isEqualToString("all")) {
                let 当前字典内容数组:NSArray = 数据字典.objectForKey(当前KEY对象) as NSArray
                for 当前内容值 in 当前字典内容数组 {
                    if (当前内容值 is NSArray) {
                        let 语言设置数组:NSArray = 当前内容值 as NSArray
                        var 未加入识别范围语言计数器:Int = 0
                        for 当前语言数组对象 in 语言设置数组
                        {
                            let 当前语言数组:NSArray = 当前语言数组对象 as NSArray
                            let 当前语言:NSString = 当前语言数组.objectAtIndex(0) as NSString
                            let 当前语言字体:NSString = 当前语言数组.objectAtIndex(1) as NSString
                            if (当前语言.isEqualToString(当前语言值) || 当前语言值.isEqualToString("all")) {
                                println(当前语言字体)
                                调出字体值 = 当前语言字体
                                for (var i:Int = 0; i < 字体值数组.count; i++) {
                                    let 已有语言字体值:NSString = 字体值数组.objectAtIndex(i) as NSString
                                    if (当前语言字体.isEqualToString(已有语言字体值)) {
                                        let 已有语言字体显示:NSString = 字体显示数组.objectAtIndex(i) as NSString
                                        调出字体显示 = 已有语言字体显示
                                        已加载完成 = false
                                        字体选择.selectItemAtIndex(i)
                                        已加载完成 = true
                                    }
                                }
                                break
                            }
                        }
                        break
                    }
                }
                break
            }
        }
        设置示例文字字体(调出字体值)
        println("✅ 读取当前项目字体（\(调出字体显示)）成功。")
        println(－－－)
    }
    
    func 设置示例文字字体(字体名:NSString)
    {
        let 设为字体 = NSFont(name: 字体名, size: 12)
        demo1.font = 设为字体
        demo2.font = 设为字体
        demo3.font = 设为字体
        demo4.font = 设为字体
        demo5.font = 设为字体
        demo6.font = 设为字体
        demo7.font = 设为字体
        demo8.font = 设为字体
        demo9.font = 设为字体
        demo10.font = 设为字体
        demo11.font = 设为字体
        demo12.font = 设为字体
        demo13.font = 设为字体
    }
    
    func 匹配内存数据()
    {
        已加载完成 = false
        println("⌛️ 开始匹配内存数据：")
        if (字体选择.indexOfSelectedItem > 1000 || 字体选择.indexOfSelectedItem < 0) {
            字体选择.selectItemAtIndex(旧字体选择)
            println("🔵 修正字体选择数据。")
        }
        if (项目选择.indexOfSelectedItem > 1000 || 项目选择.indexOfSelectedItem < 0) {
            项目选择.selectItemAtIndex(旧项目选择)
            println("🔵 修正项目选择数据。")
        }
        if (语言选择.indexOfSelectedItem > 1000 || 语言选择.indexOfSelectedItem < 0) {
            语言选择.selectItemAtIndex(旧语言选择)
            println("🔵 修正语言选择数据。")
        }
        已加载完成 = true
        println("✅ 匹配内存数据成功。")
    }
    
    func 写入配置() {
        匹配内存数据()
        var 字体选择当前选项:Int = 字体选择.indexOfSelectedItem
        if (字体选择当前选项 > 0) {
            var 项目选择当前选项:Int = 项目选择.indexOfSelectedItem
            var 语言选择当前选项:Int = 语言选择.indexOfSelectedItem
            println("⌛️ 开始进行操作缓存：")
            
            var 操作缓存:ChangeData = ChangeData()
            操作缓存.改为项目显示 = 项目显示数组.objectAtIndex(项目选择当前选项) as NSString
            操作缓存.改为项目值 = 项目值数组.objectAtIndex(项目选择当前选项) as NSString
            操作缓存.改为字体显示 = 字体显示数组.objectAtIndex(字体选择当前选项) as NSString
            操作缓存.改为字体值 = 字体值数组.objectAtIndex(字体选择当前选项) as NSString
            操作缓存.改为语言显示 = 语言显示数组.objectAtIndex(语言选择当前选项) as NSString
            操作缓存.改为语言值 = 语言值数组.objectAtIndex(语言选择当前选项) as NSString
            设置示例文字字体(操作缓存.改为字体值)
            操作缓存.数据 = 数据字典
            数据字典 = 操作缓存.开始处理操作()
            println("✅ 操作缓存成功。")
            println(－－－)
        } else {
            println("⚠️ 请选择一个字体。")
            println(－－－)
        }
    }
    
//    func alertShowHelp(alert: NSAlert!) -> Bool
//    {
//        println("TTT")
//        return true
//    }
    
    func 提示框调用完成(alert:NSAlert)
    {
        遮罩视图(false)
    }
    
    func 备份文件() -> Bool
    {
        var 是否成功:Bool = false
        println("⌛️ 检查是否有备份文件...")
        let 文件是否存在:Bool = 文件管理.fileExistsAtPath(文件路径)
        let 备份文件是否存在:Bool = 文件管理.fileExistsAtPath(备份文件路径)
        if (文件是否存在) {
            if (备份文件是否存在) {
                是否成功 = true
                println("✅ 备份文件存在。")
            } else {
                println("🔵 备份文件不存在。")
                println("⌛️ 正在创建备份文件...")
                var err:NSError? = nil
                文件管理.copyItemAtPath(文件路径, toPath: 备份文件路径, error: &err)
                if (err != nil) {
                    println("⛔️ 创建备份文件失败，可能权限不足。")
                } else {
                    是否成功 = true
                    println("✅ 文件备份完毕。")
                }
            }
        } else {
            println("⛔️ 检查是否有备份文件失败，可能权限不足。")
        }
        if (!是否成功) {
            遮罩视图(true)
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 创建备份文件失败。"
            提示框.informativeText = "备份文件或创建备份文件失败，可能权限不足。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
        }
        return 是否成功
    }
    
    @IBAction func 关于按钮点击(sender: NSButton) {
        let 打开网站:NSURL = NSURL.URLWithString("http://uuu.moe/?p=1392")
        NSWorkspace.sharedWorkspace().openURL(打开网站)
    }
    
    @IBAction func 还原按钮点击(sender: NSButton) {
        var 是否成功:Bool = false
        println(－－－)
        println("⌛️ 正在准备还原...")
        let 备份文件是否存在:Bool = 文件管理.fileExistsAtPath(备份文件路径)
        if (备份文件是否存在) {
            println("✅ 找到备份文件。")
            println("⌛️ 正在删除旧文件...")
            var err:NSError? = nil
            let 文件是否存在:Bool = 文件管理.fileExistsAtPath(文件路径)
            if (文件是否存在) {
                文件管理.removeItemAtPath(文件路径, error: &err)
            }
            if (err != nil) {
                println("⛔️ 删除旧文件失败。")
            } else {
                println("✅ 删除旧文件成功。")
            }
            println("⌛️ 正在创建备份文件...")
            文件管理.copyItemAtPath(备份文件路径, toPath: 文件路径, error: &err)
            if (err != nil) {
                println("⛔️ 还原文件失败，可能权限不足。")
                遮罩视图(true)
                let 提示框:NSAlert = NSAlert()
                提示框.addButtonWithTitle("中止")
                提示框.messageText = "⛔️ 还原文件失败。"
                提示框.informativeText = "还原文件失败，可能权限不足。"
                提示框.alertStyle = NSAlertStyle.WarningAlertStyle
                //提示框.delegate = self
                提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
            } else {
                是否成功 = true
                println("✅　一键还原完成，软件自动退出。")
            }
        } else {
            println("⛔️ 没有找到备份文件。")
            遮罩视图(true)
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 没有找到备份文件。"
            提示框.informativeText = "系统文件尚未备份，将在第一次应用设置时自动备份。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
        }
    }
    @IBAction func 确定按钮点击(sender: NSButton) {
        if (已加载完成) {
            if (备份文件()) {
                let 是否可以写入:Bool = 数据字典.writeToFile(文件路径, atomically: true)
                if (是否可以写入) {
                    压缩配置文件()
                    println("✅ 应用设置到系统成功，软件自动退出。\n建议先重新启动系统。")
                    遮罩视图(true)
                    let 提示框:NSAlert = NSAlert()
                    提示框.addButtonWithTitle("确定")
                    提示框.messageText = "✅ 应用设置到系统成功。"
                    提示框.informativeText = "请注销或重新启动计算机查看修改效果。"
                    提示框.alertStyle = NSAlertStyle.WarningAlertStyle
                    //提示框.delegate = self
                    提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
//                    system("killall Finder")
//                    exit(0)
                } else {
                    println("⛔️ 应用设置到系统失败，文件写入失败。")
                    遮罩视图(true)
                    let 提示框:NSAlert = NSAlert()
                    提示框.addButtonWithTitle("中止")
                    提示框.messageText = "⛔️ 应用设置到系统失败"
                    提示框.informativeText = "文件写入失败，操作可能被阻止。"
                    提示框.alertStyle = NSAlertStyle.WarningAlertStyle
                    //提示框.delegate = self
                    提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
                }

            }
                    } else {
            println("⛔️ 请等待上一项操作完成。")
        }
    }
    @IBAction func 取消按钮点击(sender: NSButton) {
        println("✋ 不保存设置并退出")
        exit(0)
    }
    
//    func comboBoxWillPopUp(notification: NSNotification!)
//    {
//        println(213)
//    }
    
//    override func fontManager(sender: AnyObject!, willIncludeFont fontName: String!) -> Bool
//    {
//        return true
//    }
    
//    override func fontManager(sender: AnyObject!, willIncludeFont fontName: String!) -> Bool {
//        println("CCCC")
//        return true
//    }
    
//    override func changeFont(sender: AnyObject!) {
////        let 当前字体管理:NSFontManager = sender.object as NSFontManager
//        let 当前选择字体:NSFont = 字体管理.selectedFont
//        println(当前选择字体.familyName)
//        println(当前选择字体.fontName)
//        println(当前选择字体.pointSize)
//        println(当前选择字体.displayName)
////        var fontName: String! { get }
////        var pointSize: CGFloat { get }
////        var matrix: UnsafePointer<CGFloat> { get }
////        var familyName: String! { get }
////        var displayName: String! { get }
//    }
    
    func 系统版本检查() -> Bool
    {
        println("⌛️ 正在检查系统版本...")
        
        let 系统版本支持:SystemList = SystemList()
        let 系统是否支持:Bool = 系统版本支持.系统是否支持()
        if (系统是否支持) {
            println("✅ 当前系统版本支持。")
            return true
        } else {
            println("⚠️ 当前系统版本可能不支持。")
            遮罩视图(true)
let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("知道了，继续")
            提示框.messageText = "⚠️ 当前系统版本不在支持列表内"
            提示框.informativeText = "你仍可以继续使用，但程序可能无法正常运行（包括程序发生错误或者造成异常）。在使用前请注意备份您的文件。如果你帮助进行了测试，请将终端窗口中的软件日志发送到cxchope@163.com帮助作者改进。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
            return false
        }
    }
    
    func 载入语言() -> Bool
    {
        //语言显示数组，语言值数组
        println("⌛️ 正在创建可调整语言列表...")
        语言显示数组.removeAllObjects()
        语言值数组.removeAllObjects()
        let 全部KEY:NSArray = 数据字典.allKeys
        for 当前KEY对象 in 全部KEY {
            let 当前字典内容数组:NSArray = 数据字典.objectForKey(当前KEY对象) as NSArray
            for 当前内容值 in 当前字典内容数组 {
                if (当前内容值 is NSArray) {
                    let 语言设置数组:NSArray = 当前内容值 as NSArray
                    var 未加入识别范围语言计数器:Int = 0
                    for 当前语言数组对象 in 语言设置数组
                    {
                        let 当前语言数组:NSArray = 当前语言数组对象 as NSArray
                        let 当前语言:NSString = 当前语言数组.objectAtIndex(0) as NSString
                        var 是否已有:Bool = false
                        for 已有语言对象 in 语言值数组 {
                            let 已有语言:NSString = 已有语言对象 as NSString
                            if (已有语言.isEqualToString(当前语言)) {
                                是否已有 = true
                                break
                            }
                        }
                        if (!是否已有) {
                            语言值数组.addObject(当前语言)
                            if (当前语言.isEqualToString("zh-Hans")) {
                                语言显示数组.addObject("简体中文")
                            } else if (当前语言.isEqualToString("zh-Hant")) {
                                语言显示数组.addObject("繁体中文")
                            } else if (当前语言.isEqualToString("ja")) {
                                语言显示数组.addObject("日语")
                            } else if (当前语言.isEqualToString("ko")) {
                                语言显示数组.addObject("韩语")
                            } else {
                                语言显示数组.addObject(当前语言)
                                未加入识别范围语言计数器++
                            }
                        }
                    }
                    if (未加入识别范围语言计数器 == 语言值数组.count) {
                        语言显示数组.removeAllObjects()
                        语言值数组.removeAllObjects()
                    }
                }
            }
        }
        if (语言值数组.count > 0) {
            语言显示数组.insertObject("应用到全部语言", atIndex: 0)
            语言值数组.insertObject("all", atIndex: 0)
            语言选择.reloadData()
            语言选择.selectItemAtIndex(0)
            println("✅ 创建可调整语言列表成功。")
            return true
        } else {
            println("⛔️ 创建可调整语言列表失败。")
            遮罩视图(true)
let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 创建可调整语言列表失败"
            提示框.informativeText = "由于列表格式不匹配或者不是亚洲版系统，应用无法继续。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
            return false
        }
    }
    
    func 载入字体() -> Bool
    {
        println("⌛️ 正在载入字体...")
        字体显示数组.removeAllObjects()
        字体值数组.removeAllObjects()
        let 字体列表:NSArray = 字体管理.availableFonts
        字体值数组.addObjectsFromArray(字体列表)
        for 当前字体名对象 in 字体列表 {
            let 当前字体名:NSString = 当前字体名对象 as NSString
            let 当前字体:NSFont = NSFont(name: 当前字体名, size: 50)
//            println(当前字体.familyName) //Weibei TC
//            println(当前字体.fontName) //Weibei-TC-Bold
//            println(当前字体.pointSize) //50.0
//            println(当前字体.displayName) //魏碑-繁 粗体
            let 当前字体显示名:NSString = 当前字体.displayName
            字体显示数组.addObject(当前字体显示名)
        }
        if (字体值数组.count > 0 && 字体值数组.count == 字体显示数组.count) {
            字体显示数组.insertObject("请选择字体...", atIndex: 0)
            字体值数组.insertObject("all", atIndex: 0)
            字体选择.reloadData()
            字体选择.selectItemAtIndex(0)
            println("✅ 载入字体成功。")
            return true
        } else {
            字体显示数组.removeAllObjects()
            字体值数组.removeAllObjects()
            println("⛔️ 载入字体失败。")
            遮罩视图(true)
let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 载入字体失败"
            提示框.informativeText = "列字体失败，或者系统中有无效字体。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
            return false
        }
        
//        NSFont.familyNames()
    }
    
    func 载入数据() -> Bool
    {
        println("⌛️ 正在读取系统设置...")
        数据字典 = NSMutableDictionary(contentsOfFile: 文件路径)
        项目显示数组.removeAllObjects()
        项目值数组.removeAllObjects()
        项目值数组.addObjectsFromArray(数据字典.allKeys)
        for 当前项目对象 in 数据字典.allKeys
        {
            let 当前项目:NSString = 当前项目对象 as NSString
            if (当前项目.isEqualToString("sans-serif")) {
                项目显示数组.addObject("无衬线字体设置")
            } else if (当前项目.isEqualToString("serif")) {
                项目显示数组.addObject("带衬线字体设置")
            } else if (当前项目.isEqualToString("default")) {
                项目显示数组.addObject("默认字体设置")
            } else if (当前项目.isEqualToString("cursive")) {
                项目显示数组.addObject("书写字体设置")
            } else if (当前项目.isEqualToString("fantasy")) {
                项目显示数组.addObject("幻想字体设置")
            } else if (当前项目.isEqualToString("monospace")) {
                项目显示数组.addObject("等宽字体设置")
            } else {
                项目显示数组.addObject(当前项目)
            }
        }
        
        let 载入数据完成:Bool = false
        if (项目显示数组.count > 0) {
            项目显示数组.insertObject("应用到全部设置", atIndex: 0)
            项目值数组.insertObject("all", atIndex: 0)
            项目选择.reloadData()
            项目选择.selectItemAtIndex(0)
            println("✅ 读取系统设置成功。")
            return true
        } else {
            项目显示数组.removeAllObjects()
            项目值数组.removeAllObjects()
            println("⛔️ 读取系统设置失败。")
            遮罩视图(true)
let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 读取系统设置失败"
            提示框.informativeText = "未能找到制定文件，程序无法继续。\n解析库“CoreText”出现错误。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
            return false
        }
    }
    
    func 文件校验() -> Bool
    {
        println("⌛️ 正在检查系统文件...")
        let 文件是否存在:Bool = 文件管理.fileExistsAtPath(文件路径)
        if (文件是否存在) {
            println("✅ 文件检查完成。")
        } else {
            println("⛔️ 文件检查失败。")
            遮罩视图(true)
let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 文件读取失败"
            提示框.informativeText = "未能找到指定文件，程序无法继续。\n解析库“CoreText”不完整。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
        }
        return 文件是否存在
    }
    
    func 压缩配置文件() {
        system("plutil -convert binary1 /System/Library/Frameworks/CoreText.framework/Versions/A/Resources/DefaultFontFallbacks.plist")
    }
    
    func 权限验证() -> Bool
    {
        println("⌛️ 正在验证权限...")
        let 是否可以写入:Bool = 数据字典.writeToFile(文件路径, atomically: true)
        if (是否可以写入) {
            压缩配置文件()
            println("✅ 验证权限完成。")
        } else {
            println("⚠️ 验证权限失败。")
            遮罩视图(true)
let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("知道了，继续")
            提示框.messageText = "⚠️ 验证权限失败，请从同目录中的启动器来启动。"
            提示框.informativeText = "无法对系统文件进行修改操作，可能因为权限不足。\n请从专用启动器启动本程序以获得足够的访问权限。\n您可以继续操作，但是将无法保存设置！"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            //提示框.delegate = self
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: "提示框调用完成:", contextInfo: nil)
        }
        return 是否可以写入
    }
    
    /* These two methods are required when not using bindings */
    func numberOfItemsInComboBox(aComboBox: NSComboBox!) -> Int
    {
        switch (aComboBox.tag) {
        case 100:
            return 项目显示数组.count
        case 101:
            return 字体显示数组.count
        case 102:
            return 大小显示数组.count
        case 103:
            return 语言显示数组.count
        default:
            return 0
        }
    }
    func comboBox(aComboBox: NSComboBox!, objectValueForItemAtIndex index: Int) -> AnyObject!
    {
        switch (aComboBox.tag) {
        case 100:
            return 项目显示数组.objectAtIndex(index)
        case 101:
            return 字体显示数组.objectAtIndex(index)
        case 102:
            return 大小显示数组.objectAtIndex(index)
        case 103:
            return 语言显示数组.objectAtIndex(index)
        default:
            return ""
        }
    }
//    func comboBox(aComboBox: NSComboBox!, indexOfItemWithStringValue string: String!) -> Int
//    {
//        
//    }
//    func comboBox(aComboBox: NSComboBox!, completedString string: String!) -> String!
//    {
//        
//    }
}
