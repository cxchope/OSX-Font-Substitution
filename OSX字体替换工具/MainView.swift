//
//  MainView.swift
//  OSX字体替换工具
//
//  Created by 神楽坂雅詩 on 14/8/23.
//  Copyright (c) 2014年 神楽坂雅詩. All rights reserved.
//

import Cocoa

class MainView: NSView, NSComboBoxDataSource, NSComboBoxDelegate {
    
    @IBOutlet weak var 项目选择: NSComboBox!
    @IBOutlet weak var 字体选择: NSComboBox!
    @IBOutlet weak var 大小选择: NSComboBox!
    @IBOutlet weak var 语言选择: NSComboBox!
//    @IBOutlet weak var 字体选择: NSButton!
//    @IBOutlet weak var 大小选择: NSButton!
    @IBOutlet weak var 确定按钮: NSButton!
    @IBOutlet weak var 取消按钮: NSButton!
    
    let 文件路径:NSString = "/System/Library/Frameworks/CoreText.framework/Versions/A/Resources/DefaultFontFallbacks.plist"
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
    var 数据字典:NSMutableDictionary = NSMutableDictionary.dictionary()
    var 数据字典备份:NSMutableDictionary = NSMutableDictionary.dictionary()
    
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
                    确定按钮.enabled = true
                } else {
                    确定按钮.title = "没有保存权限"
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
    func comboBoxSelectionDidChange(notification: NSNotification!)
    {
        if (已加载完成) {
            let 当前下拉框:NSComboBox = notification.object as NSComboBox
            switch (当前下拉框.tag) {
            case 100:
                //println("项目修改")
                break
            case 101:
                写入配置()
                break
            case 102:
                //println("大小修改")
                当前下拉框.selectItemAtIndex(0)
                当前下拉框.enabled = false
                break
            case 103:
                //println("语言修改")
                break
            default:
                break
            }
        }
    }
    
    func 写入配置() {
        //项目选择
        //字体选择
        //语言选择
        let 改为项目显示:NSString = 项目显示数组.objectAtIndex(项目选择.indexOfSelectedItem) as NSString
        let 改为项目值:NSString = 项目值数组.objectAtIndex(项目选择.indexOfSelectedItem) as NSString
        let 改为字体显示:NSString = 字体显示数组.objectAtIndex(字体选择.indexOfSelectedItem) as NSString
        let 改为字体值:NSString = 字体值数组.objectAtIndex(字体选择.indexOfSelectedItem) as NSString
        let 改为语言显示:NSString = 语言显示数组.objectAtIndex(语言选择.indexOfSelectedItem) as NSString
        let 改为语言值:NSString = 语言值数组.objectAtIndex(语言选择.indexOfSelectedItem) as NSString
        let 改为显示:NSString = NSString(format: "⌛️ 开始进行操作缓存：\n将处于%@时的%@改为%@字体…",改为语言显示,改为项目显示,改为字体显示)
        println(改为显示)
        println("⛔️ 制作中。")
        println(－－－)
    }
    
    @IBAction func 确定按钮点击(sender: NSButton) {
        println("确定按钮点击")
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
            println("⚠️ 当前系统版本不支持。")
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("知道了，继续")
            提示框.messageText = "⚠️ 当前系统版本不在支持列表内"
            提示框.informativeText = "你仍可以继续使用，但程序可能无法正常运行（包括程序发生错误甚至造成系统无法启动）。在使用前请注意备份您的文件。如果你帮助进行了测试，请将终端窗口中的软件日志发送到cxchope@163.com帮助作者改进。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
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
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 创建可调整语言列表失败"
            提示框.informativeText = "由于列表格式不匹配或者不是亚洲版系统，应用无法继续。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
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
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 载入字体失败"
            提示框.informativeText = "列字体失败，或者系统中有无效字体。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
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
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 读取系统设置失败"
            提示框.informativeText = "未能找到制定文件，程序无法继续。\n解析库“CoreText”出现错误。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
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
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("中止")
            提示框.messageText = "⛔️ 文件读取失败"
            提示框.informativeText = "未能找到指定文件，程序无法继续。\n解析库“CoreText”不完整。"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
        }
        return 文件是否存在
    }
    
    func 权限验证() -> Bool
    {
        println("⌛️ 正在验证权限...")
        let 是否可以写入:Bool = 数据字典.writeToFile(文件路径, atomically: true)
        if (是否可以写入) {
            println("✅ 验证权限完成。")
        } else {
            println("⚠️ 验证权限失败。")
            let 提示框:NSAlert = NSAlert()
            提示框.addButtonWithTitle("知道了，继续")
            提示框.messageText = "⚠️ 验证权限失败"
            提示框.informativeText = "无法对系统文件进行修改操作，可能因为权限不足。\n请从专用启动器启动本程序以获得足够的访问权限。\n您可以继续操作，但是将无法保存设置！"
            提示框.alertStyle = NSAlertStyle.WarningAlertStyle
            提示框.beginSheetModalForWindow(self.window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
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
