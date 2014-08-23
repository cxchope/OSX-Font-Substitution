//
//  Starter.m
//  OSX字体替换工具启动器
//
//  Created by 神楽坂雅詩 on 14/8/23.
//  Copyright (c) 2014年 神楽坂雅詩. All rights reserved.
//

#import "Starter.h"

@implementation Starter

- (void)start
{
    [self printline:"="];
    printf("字体替换工具启动器 v1.0.0\n");
    printf("http://uuu.moe\n");
    [self printline:"="];
    //OSX字体替换工具.app
//    [self chkFile];
    printf("为了修改系统字体，本程序需要以管理员权限运行才能继续。\n");
    printf("请输入你的管理员密码(不显示*号)，并按回车继续：\a\n");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"OSX字体替换工具" ofType:@"app"];
    NSString *address = [NSString stringWithFormat:@"sudo %@/Contents/MacOS/OSX字体替换工具",path];
    BOOL endid = system(address.UTF8String);
    [self printline:"="];
    if (endid == 0) {
        printf("感谢使用，再见。\n");
    } else {
        [self printline:"="];
        printf("由于出现了问题，程序已自动退出。\n请将以上日志发送到 cxchope@163.com 反馈以帮助作者改进。\n");
    }
    printf("http://uuu.moe\n");
    system("exit");
}

//- (BOOL)chkFile
//{
//    NSString *dirname = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSLog(dirname);
//    return false;
//}

- (void)printline:(const char *)linechar
{
    for (int i = 0; i < 40; i++) {
        printf(linechar);
    }
    printf("\n");
}

@end
