//
//  PageModel.h
//  ZhangChu
//
//  Created by qianfeng on 15/12/30.
//  Copyright (c) 2015年 luds. All rights reserved.
//

#import "ZXCBaseModel.h"

@interface PageModel : ZXCBaseModel

@property (nonatomic,strong) NSString *dishes_id;
@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *desc;
//视频地址
@property (nonatomic,strong) NSString *video;
//背景图片
@property (nonatomic,strong) NSString *image;
//播放次数
@property (nonatomic,strong) NSString *play;

@end
