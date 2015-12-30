//
//  ZXCCommonView.m
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCCommonView.h"

#import "ZXCCommonModel.h"
#import "UIImageView+WebCache.h"

@interface ZXCCommonView ()

/** 需要显示内容的子视图 */
@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *label;


@end

@implementation ZXCCommonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 需要在initWithFrame里面调用, 能保证在实例化的时候, 肯定有frame
        [self icon];
        [self label];
    }
    return self;
}

// 重写set方法, 在set方法中, 做界面的展示
- (void)setModel:(ZXCCommonModel *)model {
    _model = model;
    
    // 标题展示
    self.label.text = model.text;
    
    // 加载网络图标
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image]];
}



- (UIImageView *)icon {
    if (_icon == nil) {
        // 给一个大小即可
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        // 通过修改center来改变位置
        // 获取当前视图中心点的坐标
        CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f);
        
        // 中心点网上稍微偏移一下
        center.y -= 5;
        
        _icon.center = center;
        
        // 添加
        [self addSubview:_icon];
    }
    
    return _icon;
}

- (UILabel *)label {
    if (_label == nil) {
        
        // 实例化一个label
        float labelHeight = 18;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - labelHeight, CGRectGetWidth(self.frame), labelHeight)];
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.font = [UIFont systemFontOfSize:13];
                
        [self addSubview:_label];
    }
    
    return _label;
}


@end









