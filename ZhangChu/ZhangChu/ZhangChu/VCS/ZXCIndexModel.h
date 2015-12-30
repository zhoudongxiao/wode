//
//  ZXCIndexModel.h
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCBaseModel.h"

// 组模型, 存放所有分组相关的信息
@class Tags_Info;

// 空协议
@protocol ZXCRowModel
@end


@interface ZXCIndexModel : ZXCBaseModel

// 存放所有子模型的数组
@property (nonatomic, strong) NSMutableArray<ZXCRowModel> *data;

@end



// 每一行需要显示的模型
@interface ZXCRowModel : ZXCBaseModel


@property (nonatomic, copy) NSString *video1;

@property (nonatomic, copy) NSString<Optional> *content;

//@property (nonatomic, strong) NSArray<Tags_Info<Optional> *> *tags_info;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSNumber<Optional> *create_date;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *favorite;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *video;

@property (nonatomic, copy) NSString *play;

@end


// tag相关信息
@interface Tags_Info : ZXCBaseModel

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSInteger type;

@end

