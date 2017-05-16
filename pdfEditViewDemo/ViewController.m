//
//  ViewController.m
//  pdfEditViewDemo
//
//  Created by 金汕汕 on 17/5/10.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "ViewController.h"
#import "SSJPdfEditView.h"
#import "MergeVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"123");
    SSJPdfEditView *pdfEditView = [SSJPdfEditView instancePdfEditView];
    CGRect fm = self.view.bounds;
    pdfEditView.frame = fm;
    NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"pdfFile" ofType:@"pdf"];
    
    __weak ViewController *weakSelf = self;
    [pdfEditView loadPdfWithFilePath:pdfPath mergeSuccessBlock:^(NSString *path) {
        NSLog(@"合成后的pdf文件路径是--------:%@",path);
        /**< 查看合成后的pdf */
        MergeVC *mergeVC = [MergeVC new];
        mergeVC.pdfFilePath = path;
        [weakSelf presentViewController:mergeVC animated:YES completion:nil];
    } finishBlock:^(NSString *nothing) {
        /**< 点击完成批阅 */
    }];
    [self.view addSubview:pdfEditView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
