//
//  ZXCNewTableViewCell.m
//  ZhangChu
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCNewTableViewCell.h"
#import "PageModel.h"
@interface ZXCNewTableViewCell ()

@property (nonatomic,strong)UIImageView *icon;

@property(nonatomic,strong)UIImageView *player;

@property(nonatomic,strong)UILabel *label;

@end

@implementation ZXCNewTableViewCell

-(void)setModel:(PageModel *)model{
    _model = model;
    
    NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@",model.title,model.desc,model.play];
    
    //富文本
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:message];
    
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                         NSForegroundColorAttributeName:UIColorRGB(51, 51, 51)
                         } range:NSMakeRange (0,model.title.length)];
    
    
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                        NSForegroundColorAttributeName:UIColorRGB(51, 51, 51)
                         } range:NSMakeRange (model.title.length+ 1,model.desc.length)];
    
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                         NSForegroundColorAttributeName:UIColorRGB(102, 102, 102)
                         
                         } range:NSMakeRange(message.length-model.play.length - 2, model.play.length +3)];
    
    //给lable显示
    self.label.attributedText = att;
    
    
    
    
    [self player];
}


-(UIImageView *)icon{
    if (_icon == nil) {
        
        float width = 155;
        float height =110;
        _icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, width, height)];
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

-(UIImageView *)player{
    if (_player == nil) {
        _player =[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

        _player.center=CGPointMake(CGRectGetWidth(self.icon.frame ) /2.f , CGRectGetHeight(self.icon.frame) / 2.f);
        
        _player.image=[UIImage imageNamed:@"play-A"];
        
        
        [self.icon addSubview:_player];
    }
    return _player;
}

-(UILabel *)label{
    if (_label == nil) {
        _label =[[UILabel  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 10 , 5, 200, 75)];
        
        _label.numberOfLines = 4;
        [self.contentView  addSubview:_label];
        
    }
    return _label;
}
@end
