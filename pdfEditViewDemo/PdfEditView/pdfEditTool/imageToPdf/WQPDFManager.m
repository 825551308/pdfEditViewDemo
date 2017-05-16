//
//  WQPDFManager.m
//  pdfFileEdit
//
//  Created by 金汕汕 on 17/3/1.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "WQPDFManager.h"
#import <UIKit/UIKit.h>
#import "WQPathUtilities.h"
@implementation WQPDFManager

void WQDrawContent(CGContextRef myContext,
                   CFDataRef data,
                   CGRect rect)
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(data);
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider,
                                                         NULL,
                                                         NO,
                                                         kCGRenderingIntentDefault);
    CGContextDrawImage(myContext, rect, image);
    
    CGDataProviderRelease(dataProvider);
    CGImageRelease(image);
}

void MyCreatePDFFile (CFDataRef data,
                      CGRect pageRect,
                      const char *filepath,
                      CFStringRef password)
{
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    path = CFStringCreateWithCString (NULL, filepath,
                                      kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,
                                         kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    myDictionary = CFDictionaryCreateMutable(NULL,
                                             0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary,
                         kCGPDFContextTitle,
                         CFSTR("Photo from iPrivate Album"));
    CFDictionarySetValue(myDictionary,
                         kCGPDFContextCreator,
                         CFSTR("iPrivate Album"));
    if (password) {
        CFDictionarySetValue(myDictionary, kCGPDFContextUserPassword, password);
        CFDictionarySetValue(myDictionary, kCGPDFContextOwnerPassword, password);
    }
    
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    pageDictionary = CFDictionaryCreateMutable(NULL,
                                               0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks);
    boxData = CFDataCreate(NULL,(const UInt8 *)&pageRect, sizeof (CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage (pdfContext, pageDictionary);
    WQDrawContent(pdfContext,data,pageRect);
    CGPDFContextEndPage (pdfContext);
    
    CGContextRelease (pdfContext);
    CFRelease(pageDictionary);
    CFRelease(boxData);
}

+ (NSString *)pdfDestPath:(NSString *)filename
{
    return [[WQPathUtilities tmpDirectory]stringByAppendingPathComponent:filename];
}

+ (NSString *)WQCreatePDFFileWithSrc:(NSData *)imgData
                    toDestFile:(NSString *)destFileName
                  withPassword:(NSString *)pw
{
    NSString *fileFullPath = [self pdfDestPath:destFileName];
    const char *path = [fileFullPath UTF8String];
    CFDataRef data = (__bridge CFDataRef)imgData;
    UIImage *image = [UIImage imageWithData:imgData];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CFStringRef password = (__bridge CFStringRef)pw;
    
    MyCreatePDFFile(data,rect, path, password);
    NSLog(@"路径:%s",path);
    NSString *pathStr = [NSString stringWithFormat:@"%s",path];
    return pathStr;
}

+ (NSString *)WQCreatePDFFileWithSrc:(NSData *)imgData
                          toDestFile:(NSString *)destFileName
                          imageWidth:(float)imageWidth
                          imageHeight:(float)imageHeight
                        withPassword:(NSString *)pw
{
    NSString *fileFullPath = [self pdfDestPath:destFileName];
    const char *path = [fileFullPath UTF8String];
    CFDataRef data = (__bridge CFDataRef)imgData;
    UIImage *image = [UIImage imageWithData:imgData];
    CGRect rect = CGRectMake(0, 0, imageWidth, imageHeight);
    CFStringRef password = (__bridge CFStringRef)pw;
    
    MyCreatePDFFile(data,rect, path, password);
    NSLog(@"路径:%s",path);
    NSString *pathStr = [NSString stringWithFormat:@"%s",path];
    return pathStr;
}

@end
