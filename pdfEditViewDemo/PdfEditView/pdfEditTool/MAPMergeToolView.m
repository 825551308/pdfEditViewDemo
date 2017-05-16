//
//  MAPMergeToolView.m
//  tt
//
//  Created by 金汕汕 on 17/5/9.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "MAPMergeToolView.h"
#import "UIColor+Extension.h"

@implementation MAPMergeToolView

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(ButtonClickBlock)clickBlock{
    self  = [super initWithFrame:frame];
    if (self) {
        self.buttonClickBlock = clickBlock;
        [self createView];
    }
    return self;
}

/** 创建各种view */
- (void)createView{
    float topLineViewHeight = 1;
    /**< 分割线 */
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, topLineViewHeight)];
    topLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:topLineView];
    /**< 画图 */
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(0, topLineViewHeight, 50, 50)];
    [editButton setImage:[UIImage imageNamed:@"mROver_icon_sx"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = ButtonTypeOfDraw;
    [self addSubview:editButton];
    
    /**< Text框 */
    UIButton *wzButton = [[UIButton alloc]initWithFrame:CGRectMake(50, topLineViewHeight, 50, 50)];
    [wzButton setImage:[UIImage imageNamed:@"mROver_icon_wz"] forState:UIControlStateNormal];
    [wzButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    wzButton.tag = ButtonTypeOfTextWrite;
    [self addSubview:wzButton];
    
    /**< 保存 */
    UIButton *bcButton = [[UIButton alloc]initWithFrame:CGRectMake(100, topLineViewHeight, 50, 50)];
    [bcButton setImage:[UIImage imageNamed:@"mROver_icon_bc"] forState:UIControlStateNormal];
    [bcButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    bcButton.tag = ButtonTypeOfSave;
    [self addSubview:bcButton];
    
    /**< 完成 */
    UIButton *finishButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 104, topLineViewHeight, 104, 50)];
    [finishButton setImage:[UIImage imageNamed:@"mROver_icon_tj"] forState:UIControlStateNormal];
    [finishButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0,10.0 , 0.0, -0.0)];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [finishButton setTitle:@"完成批阅" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor colorWithHexString:@"#535759"] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    finishButton.tag = ButtonTypeOfFinish;
    [self addSubview:finishButton];
}

/** 按钮点击 */
- (void)buttonAction:(id)seneder{
    UIButton *actionButton = (UIButton *)seneder;
    if (self.buttonClickBlock) {
        self.buttonClickBlock(actionButton.tag);
    }
    
}

@end
