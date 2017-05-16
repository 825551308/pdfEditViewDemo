//
//  DrawToolView.h
//  LSDrawTest
//
//  Created by 金汕汕 on 17/3/1.
//  Copyright © 2017年 linyoulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSDrawView;
static NSString *const ToolNameOfBtnUndoString = @"0";//撤销
static NSString *const ToolNameOfBtnRedoString = @"1";//重做
static NSString *const ToolNameOfBtnSaveString = @"2";//保存
static NSString *const ToolNameOfBtnCleanString = @"3";//清除
static NSString *const ToolNameOfBtnCurveString = @"4";//曲线
static NSString *const ToolNameOfBtnLineString = @"5";//直线
static NSString *const ToolNameOfBtnEllipseString = @"6";//椭圆
static NSString *const ToolNameOfBtnRectString = @"7";//矩形
static NSString *const ToolNameOfBtnRecString = @"8";//录制
static NSString *const ToolNameOfBtnPlayString = @"9";//绘制
static NSString *const ToolNameOfBtnEraserString = @"10";	//橡皮擦/画笔



typedef NS_ENUM(NSUInteger, ToolName) {
    ToolNameOfBtnUndo = 0,//撤销
    ToolNameOfBtnRedo = 1,//重做
    ToolNameOfBtnSave = 2,//保存
    ToolNameOfBtnClean = 3,//清除
    ToolNameOfBtnCurve = 4,//曲线
    ToolNameOfBtnLine = 5,//直线
    ToolNameOfBtnEllipse = 6,//椭圆
    ToolNameOfBtnRect = 7,//矩形
    ToolNameOfBtnRec = 8,//录制
    ToolNameOfBtnPlay = 9,//绘制
    ToolNameOfBtnEraser = 10	//橡皮擦/画笔
};
@interface DrawToolView : UIView
typedef void (^SaveImageBlock)(UIImage *image);

@property (nonatomic,copy) SaveImageBlock saveImageBlock;

//- (instancetype)initWithFrame:(CGRect)frame toolNames:(NSArray *)toolNames drawView:(LSDrawView *)drawView numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC saveBlock:(void(^)(NSString *message))saveBlock;

/** 主动调用initWithFrame方法创建 */
- (instancetype)initWithFrame:(CGRect)frame toolNames:(NSArray *)toolNames drawView:(LSDrawView *)drawView numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC saveImageBlock:(SaveImageBlock)saveImageBlock;

/** 如果是xib加载 不是主动调用initWithFrame方法创建就需要调用此方法创建子试图 */
- (void)createViewWithToolNames:(NSArray *)toolNames drawView:(LSDrawView *)drawView numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC saveImageBlock:(SaveImageBlock)saveImageBlock;
/** 保存 */
- (NSString *)saveView;

/** 替换LSDrawView */
- (void)replaceLSDrawView:(LSDrawView *)drawView;

/** 清除 */
- (void)btnCleanClicked:(id)sender;

@end
