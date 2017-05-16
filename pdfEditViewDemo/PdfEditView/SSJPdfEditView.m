//
//  PdfEditView.m
//  pdfEditViewDemo
//
//  Created by 金汕汕 on 17/5/10.
//  Copyright © 2017年 ccs. All rights reserved.
//

#import "SSJPdfEditView.h"
#import "DrawToolView.h"
#import "MAPMergeToolView.h"
#import "LSDrawView.h"
#import "SSJImageViewWithRecognizer.h"

#import "WQPDFManager.h"
#import "PdfMergeManager.h"


#define toolDrawFrame CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)
#define toolBottomViewFrame CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - 50, [UIScreen mainScreen].bounds.size.width, 50)
#define toolDrawHeight 50
#define toolBottomViewHeight 50
@implementation PageClass

@end

@interface SSJPdfEditView()
/**  底部工具view */
@property (nonatomic,strong) IBOutlet MAPMergeToolView *bottomToolView;
/** pdf图片 */
@property (nonatomic,strong) IBOutlet SSJImageViewWithRecognizer *imageView;

/** 工具view */
@property (nonatomic,strong) DrawToolView *drawToolView;
/** 画图view */
@property (nonatomic,strong) LSDrawView *drawView;
/** 原pdf文件路径 */
@property (nonatomic,strong) NSString *pdfPath;
/** 当前是第几页 */
@property (nonatomic,assign) int pageIndex;
/** 已经加载过的最大page数 */
@property (nonatomic,assign) int showMaxpageIndex;
/** 总页数 */
@property (nonatomic,assign) NSInteger totalPage;
/** PDF资源 */
@property (nonatomic,assign) CGPDFDocumentRef pdf;
/** 已经加载过的PageClass（页数信息，包含index、image等） */
@property (nonatomic,strong) NSMutableArray *pageClassMuArray;
/** 合成后的pdf文件路径 */
@property (nonatomic,strong) NSMutableArray *pathArray;
/** pdf文件合成后的回调block */
@property (nonatomic,copy) MergeSuccessBlock mergeSuccessBlock;

/** 完成批阅按钮 点击后的回调block */
@property (nonatomic,copy) finishButtonActionBlock finishBlock;
@end

@implementation SSJPdfEditView

/** 初始化方法 */
+ (SSJPdfEditView *)instancePdfEditView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SSJPdfEditView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

/** 加载PDF资源 创建子试图 */
- (void)loadPdfWithFilePath:(NSString *)path mergeSuccessBlock:(MergeSuccessBlock)kMergeSuccessBlock finishBlock:(finishButtonActionBlock)finishBlock{
    if (kMergeSuccessBlock) {
        self.mergeSuccessBlock = kMergeSuccessBlock;
        self.finishBlock = finishBlock;
    }
    self.pdfPath = path;
    [self createView];
    [self updateDrawToolViewHeight:0.0];
}

- (void)createView{
    [self createPDFFromExistFile:self.pdfPath];
    self.pageIndex = 1;
    /**< 读取第一页的内容并显示 */
    CGImageRef imageRef = [self PDFPageToCGImage:self.pageIndex inDoc:self.pdf atScale:0];
    
    self.imageView.image = [UIImage imageWithCGImage:imageRef];
    
    self.showMaxpageIndex = self.pageIndex;
    //添加到pageClassMuArray
    PageClass *pageClass = [PageClass new];
    pageClass.img = [UIImage imageWithCGImage:imageRef];
    pageClass.imageView = self.imageView;
    pageClass.pageNum = self.pageIndex;
    if (![self kHavePageClassWithImage:self.pageIndex])     [self.pageClassMuArray addObject:pageClass];
    /**< 完成 */
    [self addSubview:self.bottomToolView];
    /**< 翻页 */
    __weak SSJPdfEditView *weakSelf = self;
    self.imageView.directionType = DirectionTypeOfY;
    self.imageView.panGesturePageBlock = ^(DragType dragType){
        if (dragType == DragTypesOfUp) {
            NSLog(@"上翻一页");
            [weakSelf lastButtonClick:nil];
        }else if (dragType == DragTypeOfNext){
            NSLog(@"下翻一页");
            [weakSelf nextButtonClick:nil];
        }
    };
}

/**< 上一页 */
- (void)lastButtonClick:(UIButton *)button{
    self.pageIndex-- ;
    if (self.pageIndex == 0){
        self.pageIndex++;
        return;
    }
    [self buttonClick:button];
}

/**< 下一页 */
- (void)nextButtonClick:(UIButton *)button{
    self.pageIndex++;
    if (self.pageIndex > self.totalPage){
        self.pageIndex--;
        return;
    }
    [self buttonClick:button];
}

-(void)buttonClick:(UIButton *)button
{
    self.imageView.transform = CGAffineTransformIdentity;
    if (self.pageIndex > self.showMaxpageIndex) {
        self.showMaxpageIndex = self.pageIndex;
    }
    //判断此图片是否已经加载过了
    if (![self kHavePageClassWithImage:self.pageIndex]){
        CGImageRef imageRef = [self PDFPageToCGImage:self.pageIndex inDoc:self.pdf atScale:0];
        self.imageView.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        PageClass *pageClass = [PageClass new];
        pageClass.img = [UIImage imageWithCGImage:imageRef];
        pageClass.imageView = self.imageView;
        pageClass.pageNum = self.pageIndex;
        [self.pageClassMuArray addObject:pageClass];
    }else{
        //读取数组内存储的已经加载过的图片
        PageClass *pageClass = self.pageClassMuArray[self.pageIndex - 1];
        self.imageView.image = pageClass.img;
    }
    /**< 将bottomToolView放到最上面 */
    [self insertSubview:self.bottomToolView atIndex:999];
}


- (void)updateDrawToolViewHeight:(float)drawToolViewHeight{
    if (drawToolViewHeight > 0) {
        self.imageView.hidden = YES;
    }else{
        [self.drawToolView removeFromSuperview];
        self.drawToolView = nil;
        self.imageView.hidden = NO;
    }
}

#pragma mark --  进入编辑模式
- (void)editButtonAction:(id)seneder{
    /**< 画图view 等同于 图片的实际大小（放大或缩小）*/
    self.drawView = [[LSDrawView alloc] initWithFrame:self.imageView.frame];
    self.drawView.brushColor = [UIColor blueColor];
    self.drawView.brushWidth = 3;
    self.drawView.shapeType = LSShapeCurve;
    self.drawView.backgroundImage = self.imageView.image;//[UIImage imageNamed:@"20130616030824963"];
    [self addSubview:self.drawView];
    __weak SSJPdfEditView *weakSelf = self;
    //工具栏
    self.drawToolView = [[DrawToolView alloc] initWithFrame:toolDrawFrame
                                                  toolNames:@[ToolNameOfBtnUndoString,ToolNameOfBtnRedoString,ToolNameOfBtnSaveString,ToolNameOfBtnCleanString,ToolNameOfBtnCurveString,ToolNameOfBtnLineString]
                                                   drawView:self.drawView
                                            numberOfEveLine:4 senderVC:self saveImageBlock:^(UIImage *image) {
                                                /**< 点击了“保存”按钮 */
                                                //[self appendNoShowPageClass];
                                                [weakSelf replaceEditedImage:image];
                                            }];
    self.drawToolView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.drawToolView];
    [self updateDrawToolViewHeight:50];
    
    /**< 将bottomToolView放到最上面 */
    [self insertSubview:self.bottomToolView atIndex:999];
    
    if ([self kHavePageClassWithImage:self.pageIndex]) {
        PageClass *pageClass = self.pageClassMuArray[self.pageIndex - 1];
        pageClass.drawView = self.drawView;
        pageClass.drawToolView = self.drawToolView;
        [self.pageClassMuArray replaceObjectAtIndex:(self.pageIndex - 1) withObject:pageClass];
    }else{
        PageClass *pageClass = [PageClass new];
        pageClass.imageView = self.imageView;
        pageClass.drawView = self.drawView;
        pageClass.pageNum = self.pageIndex;
        pageClass.drawToolView = self.drawToolView;
        [self.pageClassMuArray addObject:pageClass];
    }
}




/** 生成pdf资源/totalPage */
- (void)createPDFFromExistFile:(NSString *)aFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:aFilePath]) //如果不存在
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"文件不存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
        return;
    }
    CFStringRef path;
    CFURLRef url;
    //    CGPDFDocumentRef document;
    path = CFStringCreateWithCString(NULL, [aFilePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    self.pdf = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    NSInteger count = CGPDFDocumentGetNumberOfPages (self.pdf);
    self.totalPage = count;
    if (count == 0)
    {
        return;
    }
}


#pragma mark - pdf2img

CGContextRef CreateARGBBitmapContext (CGSize size)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = size.width;
    size_t pixelsHigh = size.height;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    
    // Use the generic RGB color space.4
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    context = CGBitmapContextCreate (NULL,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

- (CGImageRef) PDFPageToCGImage:(size_t)pageNumber inDoc:(CGPDFDocumentRef) document atScale:(float) scale {
    CGPDFPageRef	page;
    CGRect          pageSize;
    CGContextRef	outContext;
    CGImageRef	ThePDFImage;
    
    page = CGPDFDocumentGetPage (document, pageNumber);
    if(page)
    {
        pageSize = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGSize sizeTo = pageSize.size;
        if (scale != 0) {
            sizeTo.width = sizeTo.width * scale;
            sizeTo.height = sizeTo.height * scale;
        }
        else {
            scale =  (float)self.bounds.size.height / (float)sizeTo.height;
            sizeTo.width = self.bounds.size.width;
            sizeTo.height = self.bounds.size.height;
        }
        
        outContext= CreateARGBBitmapContext (sizeTo);
        if(outContext)
        {
            // Scale the context so that the PDF page is rendered
            // at the correct size for the zoom level.
            CGContextScaleCTM(outContext, scale, scale);
            CGContextDrawPDFPage(outContext, page);
            
            ThePDFImage= CGBitmapContextCreateImage(outContext);
            
            CGContextRelease(outContext);
            CGPDFPageRelease(page);
            return ThePDFImage;
        }
    }
    return NULL;
}

#pragma mark -- set get method
- (NSMutableArray *)pageClassMuArray{
    if(!_pageClassMuArray){
        _pageClassMuArray = [NSMutableArray new];
    }
    return _pageClassMuArray;
}

- (NSMutableArray *)pathArray{
    if(!_pathArray){
        _pathArray = [NSMutableArray new];
    }
    return _pathArray;
}

- (UIView *)bottomToolView{
    if (_bottomToolView.subviews.count == 0) {
        _bottomToolView = [[MAPMergeToolView alloc]initWithFrame:toolBottomViewFrame clickBlock:^(ButtonType buttonIndex) {
            switch (buttonIndex) {
                case ButtonTypeOfDraw:
                {
                    [self editButtonAction:nil];
                }
                    break;
                case ButtonTypeOfTextWrite:
                {
                    
                }
                    break;
                case ButtonTypeOfSave://保存重新合成pdf文件
                {
                    [self appendNoShowPageClass];
                }
                    break;
                case ButtonTypeOfFinish:
                {
                    if (self.finishBlock) {
                        self.finishBlock(@"");
                    }
                }
                    break;
                default:
                    break;
            }
        }];
        _bottomToolView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomToolView;
}




#pragma mark priveteMethod
#pragma mark -- 合成多个pdf  合成一个pdf 跳转webview显示
- (void)appendNoShowPageClass{
    /**< 将已经加载过的图片转成PDF文件 */
    for (PageClass *pageClass in self.pageClassMuArray) {
        NSData *data = UIImageJPEGRepresentation(pageClass.img, 1);
        NSString *pdfname = [NSString stringWithFormat:@"pageClassMuArrayPhotoToPDF%@.pdf",[self secondTime]];
        NSString *path = [WQPDFManager WQCreatePDFFileWithSrc:data toDestFile:pdfname imageWidth:self.bounds.size.width imageHeight:self.bounds.size.height withPassword:nil];
        NSLog(@"pageClassMuArray image changeTo pdf path is:%@",path);
        [self.pathArray addObject:path];
    }
    
    /**< 将没有加载过的图片转成PDF文件 */
    if (self.pageClassMuArray.count < self.totalPage) {
        for (int i = 1 ; i <= self.totalPage; i++) {
            if (i > self.showMaxpageIndex) {
                //把没有显示出来的图片转成pdf
                CGImageRef imageRef = [self PDFPageToCGImage:i inDoc:self.pdf atScale:0];
                NSData *data = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1);
                NSString *pdfname = [NSString stringWithFormat:@"noShowPhotoToPDF%@.pdf",[self secondTime]];
                NSString *path = [WQPDFManager WQCreatePDFFileWithSrc:data toDestFile:pdfname imageWidth:self.bounds.size.width imageHeight:self.bounds.size.height withPassword:nil];
                NSLog(@"no show image changeTo pdf path is:%@",path);
                [self.pathArray addObject:path];
                
            }
        }
    }
    /**< 合成后清除画笔路径文件 */
    [self.drawToolView btnCleanClicked:nil];
    NSString *mergePath = [PdfMergeManager mergePDF:self.pathArray];
    /**< 合成pdf后 回调block给控制层 */
    if (self.mergeSuccessBlock) {
        self.mergeSuccessBlock(mergePath);
    }
}
- (NSString *)secondTime{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time];
    return timeStr;
}


/** 判断 第pageIndex页的图片 是否已经加载过了 */
- (BOOL)kHavePageClassWithImage:(NSInteger)pageIndex{
    for (PageClass *pageClass in self.pageClassMuArray) {
        if(pageClass.pageNum == pageIndex && pageClass.imageView){
            return YES;
        }
    }
    return NO;
}

/** 判断 第pageIndex页的画图工具 是否已经加载过了 */
- (BOOL)kHavePageClass:(NSInteger)pageIndex{
    for (PageClass *pageClass in self.pageClassMuArray) {
        if(pageClass.pageNum == pageIndex && pageClass.drawView && pageClass.drawToolView){
            return YES;
        }
    }
    return NO;
}

#pragma mark 替换编辑后的图片
- (void)replaceEditedImage:(UIImage *)replaceImage{
    self.imageView.transform = CGAffineTransformIdentity;
    /**< 移除上一页的画布和画图工具 */
    if(self.drawToolView){
        [self updateDrawToolViewHeight:0.0];
    }
    if(self.drawView){
        [self.drawView removeFromSuperview];
        self.drawView = nil;
    }
    /**< 替换图片 */
    self.imageView.image = replaceImage;
    /**< 替换PageClass数据 */
    PageClass *pageClass = self.pageClassMuArray[self.pageIndex - 1];
    pageClass.imageView = self.imageView;
    pageClass.img = self.imageView.image;
    [self.pageClassMuArray replaceObjectAtIndex:(self.pageIndex - 1) withObject:pageClass];
    
}
@end
