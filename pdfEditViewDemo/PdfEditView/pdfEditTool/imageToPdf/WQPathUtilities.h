//
//  WQPathUtilities.h
//  pdfFileEdit
//
//  Created by 金汕汕 on 17/3/1.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPathUtilities : NSObject

+ (NSString *)directory:(NSSearchPathDirectory)dir;

+ (NSString *)documentsDirectory;

+ (NSString *)cachesDirectory;

+ (NSString *)tmpDirectory;

+ (NSString *)homeDirectory;

+ (NSString *)codeResourcesPath;
+ (NSString *)binaryPath;

@end
