//
//  UIButton+WLFButton.m
//  WaLiFang
//
//  Created by 黄孔炎 on 15/8/11.
//  Copyright (c) 2015年 hky. All rights reserved.
//

#import "UIButton+WLFButton.h"

@implementation UIButton (WLFButton)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    CGRect rect = CGRectMake(0, 0, 2, 2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [self setBackgroundImage:image forState:state];
}

@end
