//
//  MAPMergeToolView.h
//  tt
//
//  Created by 金汕汕 on 17/5/9.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonType) {
    ButtonTypeOfDraw = 0,          //画图
    ButtonTypeOfTextWrite = 1,     //text
    ButtonTypeOfSave = 2,           //保存
    ButtonTypeOfFinish = 3          //完成
};

@interface MAPMergeToolView : UIView
typedef void(^ButtonClickBlock)(ButtonType buttonIndex) ;
@property (nonatomic,copy) ButtonClickBlock buttonClickBlock;

#pragma mark -- method
- (instancetype)initWithFrame:(CGRect)frame clickBlock:(ButtonClickBlock)clickBlock;
@end
