//
//  DrawToolView.m
//  LSDrawTest
//
//  Created by 金汕汕 on 17/3/1.
//  Copyright © 2017年 linyoulu. All rights reserved.
//

#import "DrawToolView.h"
#import "LSDrawView.h"
#define  screen_width   [UIScreen mainScreen].bounds.size.width
@interface DrawToolView()<UIScrollViewDelegate>
@property (nonatomic,strong) LSDrawView *drawView;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) float scrollViewPageCount;
@property (nonatomic,strong) UIImageView *arrowImageView;//三角图片
@end

@implementation DrawToolView

//- (instancetype)initWithFrame:(CGRect)frame toolNames:(NSArray *)toolNames drawView:(LSDrawView *)drawView numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC saveBlock:(void(^)(NSString *message))saveBlock{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.drawView = drawView;
//        //    [self createView:toolNames];
//        [self buidliew:[toolNames mutableCopy] numberOfEveLine:numberOfEveLineValue senderVC:senderVC];
//        self.SaveBlock = saveBlock;
//    }
//    
//    return self;
//}

- (void)createViewWithToolNames:(NSArray *)toolNames drawView:(LSDrawView *)drawView numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC saveImageBlock:(SaveImageBlock)saveImageBlock{
    self.drawView = drawView;
    [self buidliew:[toolNames mutableCopy] numberOfEveLine:numberOfEveLineValue senderVC:senderVC];
    self.saveImageBlock = saveImageBlock;
}

- (instancetype)initWithFrame:(CGRect)frame toolNames:(NSArray *)toolNames drawView:(LSDrawView *)drawView numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC saveImageBlock:(SaveImageBlock)saveImageBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.drawView = drawView;
        //    [self createView:toolNames];
        [self buidliew:[toolNames mutableCopy] numberOfEveLine:numberOfEveLineValue senderVC:senderVC];
        self.saveImageBlock = saveImageBlock;
    }
    
    return self;
}

- (void)replaceLSDrawView:(LSDrawView *)drawView{
    self.drawView = drawView;
}

- (void)buidliew:(NSMutableArray *)titleArray  numberOfEveLine:(int)numberOfEveLineValue  senderVC:(id)senderVC{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    self.scrollViewPageCount = titleArray.count%numberOfEveLineValue == 0?(titleArray.count/numberOfEveLineValue):(titleArray.count/numberOfEveLineValue+1);
    self.scrollView.contentSize = CGSizeMake(self.scrollViewPageCount*screen_width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
     _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollViewPageCount*screen_width, 160)];
    [self.scrollView addSubview:_backView1];
    [self addSubview:self.scrollView];
    
    //创建按钮
    for (int i = 0; i < titleArray.count; i++) {
        CGRect frame = CGRectMake(10+i*screen_width/numberOfEveLineValue, 10, screen_width/numberOfEveLineValue-20, 30);
        UIButton *bt =[self createButton:[titleArray[i] integerValue] ];
        bt.frame = frame;
        [_backView1 addSubview:bt];
        
    }
//    self.senderViewController = senderVC;
    
    self.arrowImageView = [[UIImageView alloc]init];
    self.arrowImageView.image = [UIImage imageNamed:@"arrowIcon"];
    self.arrowImageView.frame = CGRectMake( (screen_width - 20)/2, 40, 30, 10);
    [self addSubview:self.arrowImageView];
    
}




- (UIButton *)createButton:(ToolName)toolName{
    NSArray *titleArr = @[@"撤销",@"重做",@"保存",@"清除",@"曲线",@"直线",@"椭圆",@"矩形",@"录制",@"绘制",@"橡皮擦/画笔"];
    NSArray *methodName = @[@"btnUndoClicked:",@"btnRedoClicked:",@"btnSaveClicked:",@"btnCleanClicked:",@"btnCurveClicked:",@"btnLineClicked:",@"btnEllipseClicked:",@"btnRectClicked:",@"btnRecClicked:",@"btnPlayClicked:",@"btnEraserClicked"];
    
    switch (toolName) {
        case ToolNameOfBtnEraser:
        {
            UIButton *btnEraser = [UIButton buttonWithType:UIButtonTypeCustom];
            btnEraser.backgroundColor = [UIColor orangeColor];
            [btnEraser setTitle:@"橡皮擦" forState:UIControlStateNormal];
            [btnEraser setTitle:@"画笔" forState:UIControlStateSelected];
            
            [btnEraser addTarget:self action:@selector(btnEraserClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            return btnEraser;
        }
            break;
        
        default:
        {
            UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeCustom];
            btnUndo.backgroundColor = [UIColor orangeColor];
            [btnUndo setTitle:titleArr[toolName] forState:UIControlStateNormal];
            SEL mo = NSSelectorFromString(methodName[toolName]);
            [btnUndo addTarget:self action:mo forControlEvents:UIControlEventTouchUpInside];
            
            return btnUndo;
        }break;
            
    }
    
}


- (void)btnRecClicked:(id)sender
{
    [self.drawView testRecToFile];
}

- (void)btnPlayClicked:(id)sender
{
    [self.drawView testPlayFromFile];
}


- (void)btnSaveClicked:(id)sender//点击保存 回调block 由外界统一调用save方法
{
//    if (self.SaveBlock) {
//        self.SaveBlock(@"");
//    }
//    [self.drawView save];
    if (self.saveImageBlock) {
        self.saveImageBlock([self.drawView saveToImage]);
    }
    ;
}

/** 清除 */
- (void)btnCleanClicked:(id)sender
{
    [self.drawView clean];
}


- (void)btnRectClicked:(id)sender
{
    self.drawView.shapeType = LSShapeRect;
}

- (void)btnEllipseClicked:(id)sender
{
    self.drawView.shapeType = LSShapeEllipse;
}

- (void)btnLineClicked:(id)sender
{
    self.drawView.shapeType = LSShapeLine;
}

- (void)btnCurveClicked:(id)sender
{
    self.drawView.shapeType = LSShapeCurve;
}

- (void)btnEraserClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.selected)
    {
        btn.selected = NO;
        
        //使用画笔
        self.drawView.isEraser = NO;
    }
    else
    {
        btn.selected = YES;
        
        //使用橡皮擦
        self.drawView.isEraser = YES;
    }
}

- (void)btnUndoClicked:(id)sender
{
    [self.drawView unDo];
}

- (void)btnRedoClicked:(id)sender
{
    [self.drawView reDo];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = (self.scrollView.frame.size.width*0.5+self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
//    self.pageControl.currentPage=(self.scrollView.frame.size.width*0.5+self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
    if (currentPage == self.scrollViewPageCount - 1) {
//        NSLog(@"到底啦:%d --- %f",currentPage,self.scrollViewPageCount);
        self.arrowImageView.hidden = YES;
    }else{
//        NSLog(@"还有下一页:%d --- %f",currentPage,self.scrollViewPageCount);
        self.arrowImageView.hidden = NO;
    }
}

- (NSString *)saveView{
    NSString *path = [self.drawView save];
    return path;
}

@end
