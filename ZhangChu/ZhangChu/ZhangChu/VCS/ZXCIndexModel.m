//
//  ZXCIndexModel.m
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCIndexModel.h"

@implementation ZXCIndexModel



@end


@implementation ZXCRowModel


+ (NSDictionary *)objectClassInArray{
    return @{@"tags_info" : [Tags_Info class]};
}

// 映射
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"id": @"ID",
                                 @"description": @"desc"}];
}

@end

@implementation Tags_Info

@end


