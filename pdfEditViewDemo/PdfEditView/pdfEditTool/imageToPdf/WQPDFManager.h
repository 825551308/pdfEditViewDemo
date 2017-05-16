//
//  WQPDFManager.h
//  pdfFileEdit
//
//  Created by 金汕汕 on 17/3/1.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPDFManager : NSObject

/**
 *  @brief  创建PDF文件
 *
 *  @param  imgData         NSData型   照片数据
 *  @param  destFileName    NSString型 生成的PDF文件名
 *  @param  pw              NSString型 要设定的密码
 */
+ (NSString *)WQCreatePDFFileWithSrc:(NSData *)imgData
                    toDestFile:(NSString *)destFileName
                  withPassword:(NSString *)pw;

+ (NSString *)WQCreatePDFFileWithSrc:(NSData *)imgData
                          toDestFile:(NSString *)destFileName
                          imageWidth:(float)imageWidth
                         imageHeight:(float)imageHeight
                        withPassword:(NSString *)pw;


/**
 *  @brief  抛出pdf文件存放地址
 *
 *  @param  filename    NSString型 文件名
 *
 *  @return NSString型 地址
 */
+ (NSString *)pdfDestPath:(NSString *)filename;

@end
