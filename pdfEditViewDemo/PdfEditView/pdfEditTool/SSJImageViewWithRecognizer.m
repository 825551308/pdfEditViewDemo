//
//  SSJImageViewWithRecognizer.m
//  tt
//
//  Created by 金汕汕 on 17/5/8.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "SSJImageViewWithRecognizer.h"
#define SSJscreen_width [UIScreen mainScreen].bounds.size.width
#define SSJscreen_height [UIScreen mainScreen].bounds.size.height
#define MaxSCale 2.0  //最大缩放比例
#define MinScale 0.5  //最小缩放比例
//static CGFloat totalScale;
@interface SSJImageViewWithRecognizer()
    @property (nonatomic,assign) CGRect oldFrame;
    @property (nonatomic,assign) CGRect largeFrame;
@end
@implementation SSJImageViewWithRecognizer


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.oldFrame = self.frame;
        //点击手势
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgToSmall:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer
                                            alloc]initWithTarget:self action:@selector(pinchMethod:)];
        [self addGestureRecognizer:pinch];
        //拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doMoveAction:)];
        [self addGestureRecognizer:pan];
        
        self.totalScale = 1.0;
    }
    return self;
}

- (void)layoutSubviews{
    if (CGRectEqualToRect(self.oldFrame, CGRectZero)) {
        self.oldFrame = self.frame;
         self.largeFrame = CGRectMake(0 - self.oldFrame.size.width, 0 - self.oldFrame.size.height, 3 * self.oldFrame.size.width, 3 * self.oldFrame.size.height);
        self.totalScale = 1.0;
        //点击手势
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgToSmall:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer
                                            alloc]initWithTarget:self action:@selector(pinchMethod:)];
        [self addGestureRecognizer:pinch];
        //拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doMoveAction:)];
        [self addGestureRecognizer:pan];
    }
    
    
    
    
}

//图片点击还原
- (void)imgToSmall:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    imageView.frame = self.oldFrame;
    self.totalScale = 1.0;
}

//图片捏合
- (void)pinchMethod:(UIPinchGestureRecognizer *)pinch{
    
    UIImageView *showImgView = (UIImageView *)pinch.view;
    UIView *view = pinch.view;
    CGRect f = showImgView.frame;
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinch.scale, pinch.scale);
        if (showImgView.frame.size.width < self.oldFrame.size.width) {
            showImgView.frame = self.oldFrame;
            //让图片无法缩得比原图小
        }else
        if (showImgView.frame.size.width > 3 * self.oldFrame.size.width) {
            
            showImgView.frame = CGRectMake(f.origin.x, f.origin.y, self.largeFrame.size.width, self.largeFrame.size.height);
        }else if(view.frame.size.width < f.size.width){//缩小情况下
            CGRect fr = showImgView.frame;
            fr.origin.x = 0;
            showImgView.frame = fr;
            NSLog(@"X:%f Y:%f",showImgView.frame.origin.x,showImgView.frame.origin.y);
        }
        pinch.scale = 1;
//        NSLog(@"-- 85");
    }else
//        NSLog(@"-- 87");
    if (pinch.state == UIGestureRecognizerStateEnded && showImgView.frame.size.width == self.oldFrame.size.width) {
        showImgView.frame = self.oldFrame;
    }
}

//拖动
- (void)doMoveAction:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.numberOfTouches > 1){
//        NSLog(@"return 91");
        return;
    }
    CGPoint point = [recognizer translationInView:self];
    /**< 当拖动结束 判断如果当前是原始大小  则进行上下翻页 */
    if (self.directionType != DirectionTypeOfNormal && recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.frame.size.width == self.oldFrame.size.width) {
            [self panGestureWithDirectionTypeWithcGPoint:point];
//            NSLog(@"return 103");
            return;//如果等于1倍 翻页
        }
    }
    
    if (self.frame.size.width <= self.oldFrame.size.width) {//NSLog(@"return 108");
        return;//如果小于等于1倍 不允许拖动
    }

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // Figure out where the user is trying to drag the view.
        CGPoint translation = [recognizer translationInView:window];
        
        UIImageView *imgView = (UIImageView *)recognizer.view;
    
        if (self.frame.size.width <= self.oldFrame.size.width) {
            CGPoint newCenter = CGPointMake(imgView.center.x+ translation.x,
                                            imgView.center.y + translation.y);//    限制屏幕范围：
            newCenter.y = MAX(imgView.frame.size.height/2, newCenter.y);
            newCenter.y = MIN(window.frame.size.height - imgView.frame.size.height/2 ,  newCenter.y);
            newCenter.x = MAX(imgView.frame.size.width/2, newCenter.x);
            newCenter.x = MIN(window.frame.size.width - imgView.frame.size.width/2,newCenter.x);
            
            imgView.center = newCenter;
            [recognizer setTranslation:CGPointZero inView:window];
        }else{
            
            float bNum = self.frame.size.width/self.oldFrame.size.width;
            float widLef = self.oldFrame.size.width * (bNum-1) /2;
            float heiTop = self.oldFrame.size.height * (bNum-1) /2;
            if (point.x>0) {//往右拖
                if (imgView.frame.origin.x  > 0 ) {
                    NSLog(@"右拉超出了");
                    return;
                }
            }else if(point.x<0){//往左拖
                if (imgView.frame.origin.x  < -2*widLef ) {
                    NSLog(@"左拉超出了");
                    return;
                }
            }
            
            if (point.y < 0){//往上拖
                if (imgView.frame.origin.y  < -2*heiTop  ) {
                    NSLog(@"上拉超出了");
                    return;
                }
            }else if (point.y > 0) {//往下拖
                if (imgView.frame.origin.y  > 0 ) {
                    NSLog(@"下拉超出了");
                    return;
                }
            }
            imgView.center = CGPointMake(imgView.center.x + translation.x,
                                         imgView.center.y + translation.y);
            
            [recognizer setTranslation:CGPointZero inView:window];
        }
}

/** 翻页 */
- (void)panGestureWithDirectionTypeWithcGPoint:(CGPoint)point{
    /**< DirectionTypeOfY */
    if(self.directionType == DirectionTypeOfY){
        if (point.y < 0){//往上翻页
            if (self.panGesturePageBlock) {
                self.panGesturePageBlock(DragTypesOfUp);
            }
        }else if (point.y > 0){//往下翻页
            if (self.panGesturePageBlock) {
                self.panGesturePageBlock(DragTypeOfNext);
            }
        }
    }
    /**< DirectionTypeOfX */
    if(self.directionType == DirectionTypeOfX){
        if (point.x < 0){//往左翻页
            if (self.panGesturePageBlock) {
                self.panGesturePageBlock(DragTypesOfUp);
            }
        }else if (point.x  > 0){//往右翻页
            if (self.panGesturePageBlock) {
                self.panGesturePageBlock(DragTypeOfNext);
            }
        }
    }

}
@end
