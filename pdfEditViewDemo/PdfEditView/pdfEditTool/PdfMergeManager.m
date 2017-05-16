//
//  PdfMergeManager.m
//  tt
//
//  Created by 金汕汕 on 17/5/5.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "PdfMergeManager.h"
#import <QuartzCore/QuartzCore.h>
@implementation PdfMergeManager


+ (NSString *)mergePDF:(NSArray *)paths

{
    
   
    
    
    
    return [self joinPDF:paths];
    
}


/** 测试 */
+ (void)mergePDFTest

{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //    NSString *filePath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"开发证书和授权文件解释.pdf"];
    //
    //    NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"金汕汕7月通讯发票.pdf"];
    
    NSString *filePath1 = @"/Users/jinshanshan/Desktop/手写签批/测试可删除 /tt/tt/金汕汕7月通讯发票.pdf";
    NSString *filePath2 = @"/Users/jinshanshan/Desktop/手写签批/测试可删除 /tt/tt/开发证书和授权文件解释.pdf";
    
    NSArray *PDFURLS = [NSArray arrayWithObjects:filePath1,filePath2, nil];
    
    
    
    [self joinPDF:PDFURLS];
    
}



+ (NSString *)joinPDF:(NSArray *)listOfPaths {
    
    // File paths
    
    NSString *fileName = [NSString stringWithFormat:@"公文%d.pdf",arc4random_uniform(100)];
    
    NSString *pdfPathOutput = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    
    
    CFURLRef pdfURLOutput = (  CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:pdfPathOutput]);
    
    
    
    NSInteger numberOfPages = 0;
    
    // Create the output context
    
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    
    
    for (NSString *source in listOfPaths) {
        
        CFURLRef pdfURL = (  CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:source]);
        
        
        
        //file ref
        
        CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL);
        
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfRef);
        
        
        
        // Loop variables
        
        CGPDFPageRef page;
        
        CGRect mediaBox;
        
        
        
        // Read the first PDF and generate the output pages
        
        //        NSLog(@"GENERATING PAGES FROM PDF 1 (%@)...", source);
        
        for (int i=1; i<=numberOfPages; i++) {
            
            page = CGPDFDocumentGetPage(pdfRef, i);
            
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            
            CGContextBeginPage(writeContext, &mediaBox);
            
            CGContextDrawPDFPage(writeContext, page);
            
            CGContextEndPage(writeContext);
            
        }
        
        
        
        CGPDFDocumentRelease(pdfRef);
        
        CFRelease(pdfURL);
        
    }
    
    CFRelease(pdfURLOutput);
    
    
    
    // Finalize the output file
    
    CGPDFContextClose(writeContext);
    
    CGContextRelease(writeContext);
    
    
    
    return pdfPathOutput;
    
}
@end
