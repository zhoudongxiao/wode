//
//  ZXCVideoTableViewCell.m
//  ZhangChu
//
//  Created by luds on 15/12/29.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCVideoTableViewCell.h"

#import "ZXCIndexModel.h"
#import "UIImageView+WebCache.h"


#define PADDING 10

@interface ZXCVideoTableViewCell ()

/** 背景高清无码大图 */
@property (nonatomic, strong) UIImageView *icon;
/** 播放图标 */
@property (nonatomic, strong) UIImageView *play;

/** 信息展示 */
@property (nonatomic, strong) UILabel *label;


@end


@implementation ZXCVideoTableViewCell


- (void)setModel:(ZXCRowModel *)model {
    _model = model;
    
    // 设置选中的样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, 0, SCREEN_WIDTH - PADDING * 2, SCREEN_WIDTH / 2.f)];
        
        //
        _icon.backgroundColor = [UIColor redColor];
        
        // 添加
        [self.contentView addSubview:_icon];
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
        _label = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, CGRectGetHeight(self.icon.frame) - 30 - PADDING, 250, 30)];
        
        // 设置行数为..
        _label.numberOfLines = 2;
        
        // 添加
        [self.icon addSubview:_label];
    }
    
    return _label;
}




@end






