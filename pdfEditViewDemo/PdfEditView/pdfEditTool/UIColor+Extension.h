//
//  UIColor+Extension.h
//  MobileApplicationPlatform
//
//  Created by administrator on 15-5-18.
//  Copyright (c) 2015年 HCMAP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;




//导航栏颜色
+ (UIColor *)themeNavBarTintColor;
+ (UIColor *)themeNavBarTitleTextColor;

//背景颜色
+ (UIColor *)themeBackgroundColor;

//分隔线颜色
+ (UIColor *)themeSeparationLineColor;


//搜索栏颜色
+ (UIColor *)themeSearchBarBKColor;

+ (UIColor *)themeSearchBarTextFieldBKColor;

//UIlabe

+ (UIColor *)themeLabelTextColor;
+ (UIColor *)themeDetailLabelTextColor;

//UIButton--背景
+ (UIColor *)themeButtonRedBKColor;
+ (UIColor *)themeButtonBlueBKColor;
+ (UIColor *)themeButtonGreenBKColor;
+ (UIColor *)themeButtonUnableBKColor;
+ (UIColor *)themeButtonGrassGreenColor;

//按钮文字
+ (UIColor *)themeButtonNormalTextColor;
+ (UIColor *)themeButtonUnableTextColor;

@end
