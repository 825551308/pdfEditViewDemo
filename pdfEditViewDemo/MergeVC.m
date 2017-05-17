//
//  MergeVC.m
//  tt
//
//  Created by 金汕汕 on 17/5/5.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "MergeVC.h"

@interface MergeVC ()
@property (nonatomic,strong) IBOutlet UIWebView *wbView;
@end

@implementation MergeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"大大");
    // Do any additional setup after loading the view from its nib.
    [self loadDocument:self.pdfFilePath inView:self.wbView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)loadDocument:(NSString *)documentPath inView:(UIWebView *)webView
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURL *url = [NSURL fileURLWithPath:documentPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
     [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
