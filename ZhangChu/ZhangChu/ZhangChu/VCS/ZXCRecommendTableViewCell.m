//
//  ZXCRecommendTableViewCell.m
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCRecommendTableViewCell.h"

#import "ZXCIndexModel.h"

#import "UIImageView+WebCache.h"

#define PADDING 10

#define left_tag 878


@interface ZXCRecommendTableViewCell ()

// 左边的视图
@property (nonatomic, strong) ZXCRecommendView *leftView;
// 右边的视图
@property (nonatomic, strong) ZXCRecommendView *rightView;

@end

@implementation ZXCRecommendTableViewCell

- (void)setModels:(NSArray *)models {
    _models = models;
    
    // 取消选中的样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置界面展示的内容
    self.leftView.model = models.firstObject;
    self.rightView.model = models.lastObject;
}


- (ZXCRecommendView *)leftView {
    if (_leftView == nil) {
        float width = (SCREEN_WIDTH - PADDING * 2.5) / 2.f;
        float height = width * 2 / 3.f;
        _leftView = [[ZXCRecommendView alloc] initWithFrame:CGRectMake(PADDING, 0, width, height)];
        
        // 添加点击手势
        _leftView.tag = left_tag;
        [_leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        
        [self.contentView addSubview:_leftView];
    }
    return _leftView;
}

- (ZXCRecommendView *)rightView {
    if (_rightView == nil) {
        float width = (SCREEN_WIDTH - PADDING * 2.5) / 2.f;
        float height = width * 2 / 3.f;
        
        _rightView = [[ZXCRecommendView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftView.frame) + PADDING / 2.f, 0, width, height)];
        
        // 添加点击手势
        _rightView.tag = left_tag + 1;
        
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        
        [self.contentView addSubview:_rightView];
    }
    return _rightView;
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    // 事件的点击回调
    if (self.clickCallBack) {
        // 回调
        ZXCRowModel *model = self.models[tap.view.tag - left_tag];
        
        self.clickCallBack(model);
    }
}

@end









@interface ZXCRecommendView ()

/** 背景高清无码大图 */
@property (nonatomic, strong) UIImageView *icon;
/** 播放图标 */
@property (nonatomic, strong) UIImageView *play;
/** 信息展示 */
@property (nonatomic, strong) UILabel *label;

@end




@implementation ZXCRecommendView

- (void)setModel:(ZXCRowModel *)model {
    _model = model;
    
    // 背景图
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
    // 播放按钮
    [self play];
    
    // 左下角信息
    NSString *message = [NSString stringWithFormat:@"%@\n%@", model.title, model.desc];
    
    // 富文本
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:message];
    
    // 设置第一行字体
    [attTitle addAttributes:@{
                              NSFontAttributeName: [UIFont systemFontOfSize:13],
                              NSForegroundColorAttributeName: [UIColor whiteColor]
                              } range:NSMakeRange(0, model.title.length)];
    
    // 设置第二行字体
    [attTitle addAttributes:@{
                              NSFontAttributeName: [UIFont systemFontOfSize:11],
                              NSForegroundColorAttributeName: [UIColor whiteColor]
                              } range:NSMakeRange(model.title.length + 1, model.desc.length)];
    
    // 设置label富文本标题
    self.label.attributedText = attTitle;
}

#pragma mark ========= 关于界面展示 =============
- (UIImageView *)icon {
    
    if (_icon == nil) {
        // 图标
        _icon = [[UIImageView alloc] initWithFrame:self.bounds];
        
        //
        _icon.backgroundColor = [UIColor redColor];
        
        // 添加
        [self addSubview:_icon];
    }
    
    return _icon;
}

// 播放图标
- (UIImageView *)play {
    if (_play == nil) {
        // 实例化, 添加到图片上
        // 宽高都是50
        float width = 30;
        _play = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.icon.frame) - width - PADDING, CGRectGetHeight(self.icon.frame) - width - PADDING, width, width)];
        
        // 设置图片
        _play.image = [UIImage imageNamed:@"play-A"];
        
        // 添加
        [self.icon addSubview:_play];
    }
    return _play;
}

// 左下角显示信息的label
- (UILabel *)label {
    if (_label == nil) {
        // 实例化label
        _label = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, CGRectGetHeight(self.icon.frame) - 30 - PADDING, 150, 30)];
        
        // 设置行数为..
        _label.numberOfLines = 2;
        
        // 添加
        [self.icon addSubview:_label];
    }
    
    return _label;
}


@end