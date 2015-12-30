//
//  UIImage+ZXCOriginal.m
//  ZhangChu
//
//  Created by luds on 15/12/28.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "UIImage+ZXCOriginal.h"

@implementation UIImage (ZXCOriginal)

// 如果是在iOS7之后, 对图片做一个原色的处理
- (UIImage *)originalImage {
    
    // 因为我们的工程最低支持的系统版本是 iOS 8.0  所以不可能出现iOS 7之前的问题, 所以在这里, 不用做版本的判断
    UIImage *image = [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}
















@end
