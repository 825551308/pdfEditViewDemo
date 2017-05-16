//
//  PdfMergeManager.h
//  tt
//
//  Created by 金汕汕 on 17/5/5.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PdfMergeManager : NSObject

/**
 *  多个PDF路径 合成一个pdf
 *
 *  @param paths <#paths description#>
 *
 *  @return 返回合成后的PDF路径
 */
+ (NSString *)mergePDF:(NSArray *)paths;
@end
