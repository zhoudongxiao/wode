//
//  ZXCCommonView.h
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCCommonModel;

@interface ZXCCommonView : UIView

/** 这个属性, 用来接收外界传过来的模块信息 */
@property (nonatomic, strong) ZXCCommonModel *model;

@end












