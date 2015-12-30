//
//  PageModel.m
//  ZhangChu
//
//  Created by qianfeng on 15/12/30.
//  Copyright (c) 2015年 luds. All rights reserved.
//

#import "PageModel.h"

@implementation PageModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end
