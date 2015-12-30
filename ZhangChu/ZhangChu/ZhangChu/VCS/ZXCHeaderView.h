//
//  ZXCHeaderView.h
//  ZhangChu
//
//  Created by luds on 15/12/28.
//  Copyright © 2015年 luds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCAdModel;
@class ZXCCommonModel;

@interface ZXCHeaderView : UIView


// 在这里需要一个属性或者方法, 来接收vc里面传过来的所有的广告的信息
// 并且提供点击的回调
- (void)setAdsData:(NSArray *)allAds
     clickCallBack:(void (^) (ZXCAdModel * model))click;


// 在这里, 同样需要一个方法, 用来接收vc里面传过来的所有功能模型的信息
// 并提供点击回调
- (void)setCommonData:(NSArray *)allData
        clickCallBacl:(void (^)(ZXCCommonModel * model))click;













@end
