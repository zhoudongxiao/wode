//
//  ZXCRecommendTableViewCell.h
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCRowModel;

@interface ZXCRecommendTableViewCell : UITableViewCell

// 需要在外界传过来一个数组, 这个数组中存放的是这一行显示的两个数据
@property (nonatomic, strong) NSArray *models;

// 点击的回调
@property (nonatomic, copy) void (^clickCallBack)(ZXCRowModel * model);

@end



@class ZXCRowModel;
// 推荐视图, 把左右两个视图抽取一个类出来
@interface ZXCRecommendView : UIView

@property (nonatomic, strong) ZXCRowModel *model;

@end
