//
//  WQPathUtilities.m
//  pdfFileEdit
//
//  Created by 金汕汕 on 17/3/1.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "WQPathUtilities.h"

@implementation WQPathUtilities

+ (NSString *)directory:(NSSearchPathDirectory)dir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
    NSString *dirStr = [paths objectAtIndex:0];
    return dirStr;
}

+ (NSString *)documentsDirectory
{
    return [WQPathUtilities directory:NSDocumentDirectory];
}

+ (NSString *)cachesDirectory
{
    return [WQPathUtilities directory:NSCachesDirectory];
}

+ (NSString *)tmpDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString *)homeDirectory
{
    return NSHomeDirectory();
}

+ (NSString *)codeResourcesPath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *tmpPath = [[WQPathUtilities documentsDirectory] stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                         stringByAppendingPathExtension:@"app"];
    NSString *sigPath = [[appPath stringByAppendingPathComponent:@"_CodeSignature"]
                         stringByAppendingPathComponent:@"CodeResources"];
    return sigPath;
}

+ (NSString *)binaryPath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *tmpPath = [[WQPathUtilities documentsDirectory] stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                         stringByAppendingPathExtension:@"app"];
    NSString *binaryPath = [appPath stringByAppendingPathComponent:excutableName];
    return binaryPath;
}

@end
