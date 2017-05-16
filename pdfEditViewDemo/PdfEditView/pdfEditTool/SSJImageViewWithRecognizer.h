//
//  SSJImageViewWithRecognizer.h
//  tt
//
//  Created by 金汕汕 on 17/5/8.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DragType) {
    DragTypesOfUp = 1,          //网上翻页
    DragTypeOfNext = 2          //往下翻页
};
typedef NS_ENUM(NSInteger, DirectionType) {
    DirectionTypeOfNormal = 0,          //手势不翻页
    DirectionTypeOfY = 1,          //上下翻页
    DirectionTypeOfX = 2          //左右翻页
};

@interface SSJImageViewWithRecognizer : UIImageView
typedef void(^PanGesturePageBlock)(DragType dragType);

@property (nonatomic,assign)  CGFloat totalScale;
/** 翻页回调 block */
@property (nonatomic,copy) PanGesturePageBlock panGesturePageBlock;
/** 翻页类型：上下翻／左右翻 */
@property (nonatomic,assign) DirectionType directionType;
@end
