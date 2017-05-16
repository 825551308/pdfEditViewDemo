//
//  PdfEditView.h
//  pdfEditViewDemo
//
//  Created by 金汕汕 on 17/5/10.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSDrawView;
@class DrawToolView;
@class SSJImageViewWithRecognizer;
@interface SSJPdfEditView : UIView

typedef void (^MergeSuccessBlock)(NSString *path);
typedef void (^finishButtonActionBlock)(NSString *nothing);
+ (SSJPdfEditView *)instancePdfEditView;
/** 加载pdf资源 */
- (void)loadPdfWithFilePath:(NSString *)path mergeSuccessBlock:(MergeSuccessBlock)kMergeSuccessBlock finishBlock:(finishButtonActionBlock)finishBlock;

@end


@interface PageClass : NSObject
@property (nonatomic,strong) SSJImageViewWithRecognizer *imageView;
@property (nonatomic,strong) UIImage *img;
@property (nonatomic,strong) LSDrawView *drawView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) DrawToolView *drawToolView;
@end

/** *************************** 功能说明
    背景：SSJImageViewWithRecognizer（展示每一页）
    画图工具：DrawToolView（工具）＋LSDrawView（画布）
    底部工具view：MAPMergeToolView
    PS:
    DrawToolView：撤销、重做、保存、清除、曲线、直线
    底部工具view：编辑、保存、完成批阅
 */

/** *************************** 使用案例
     - (void)viewDidLoad {
         [super viewDidLoad];
         SSJPdfEditView *pdfEditView = [SSJPdfEditView instancePdfEditView];
         CGRect fm = self.view.bounds;
         pdfEditView.frame = fm;
         NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"pdfFile" ofType:@"pdf"];
         
         __weak ViewController *weakSelf = self;
         [pdfEditView loadPdfWithFilePath:pdfPath mergeSuccessBlock:^(NSString *path) {
         NSLog(@"合成后的pdf文件路径是--------:%@",path);
         } finishBlock:^(NSString *nothing) {
         //点击完成批阅 
        }];
        [self.view addSubview:pdfEditView];
    }
 */