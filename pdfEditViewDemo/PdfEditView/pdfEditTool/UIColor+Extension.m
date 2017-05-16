//
//  UIColor+Extension.m
//  MobileApplicationPlatform
//
//  Created by administrator on 15-5-18.
//  Copyright (c) 2015年 HCMAP. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}


//导航栏颜色
+ (UIColor *)themeNavBarTintColor
{
    return [UIColor colorWithHexString:@"#51afe6"];
    
}


+ (UIColor *)themeNavBarTitleTextColor
{
    return [UIColor colorWithHexString:@"#ffffff"];
    
}

//背景颜色
+ (UIColor *)themeBackgroundColor
{
    return [UIColor colorWithHexString:@"#ebebeb"];
    
}

//分隔线颜色
+ (UIColor *)themeSeparationLineColor
{
    return [UIColor colorWithHexString:@"#d9d9d9"];
    
}


//搜索栏颜色
+ (UIColor *)themeSearchBarBKColor
{
    return [UIColor colorWithHexString:@"#ebebeb"];
    
}

+ (UIColor *)themeSearchBarTextFieldBKColor
{
    return [UIColor colorWithHexString:@"#ffffff"];
    
}

//UIlabe

+ (UIColor *)themeLabelTextColor
{
    return [UIColor colorWithHexString:@"#333333"];
    
}

+ (UIColor *)themeDetailLabelTextColor
{
    return [UIColor colorWithHexString:@"#999999"];
    
}


//UIButton--背景
+ (UIColor *)themeButtonRedBKColor
{
    return [UIColor colorWithHexString:@"#ff5013"];
    
}

+ (UIColor *)themeButtonBlueBKColor
{
    return [UIColor colorWithHexString:@"#51afe6"];
    
}

+ (UIColor *)themeButtonGreenBKColor
{
    return [UIColor colorWithHexString:@"#12ac7f"];
    
}

+ (UIColor *)themeButtonUnableBKColor
{
    return [UIColor colorWithHexString:@"#cccccc"];
    
}

+ (UIColor *)themeButtonGrassGreenColor{
    return [UIColor colorWithHexString:@"#86b952"];
}


//按钮文字
+ (UIColor *)themeButtonNormalTextColor
{
    return [UIColor colorWithHexString:@"#ffffff"];
    
}

+ (UIColor *)themeButtonUnableTextColor
{
    return [UIColor colorWithHexString:@"#e5e5e5"];
    
}

@end
