//
//  ZXCHeaderView.m
//  ZhangChu
//
//  Created by luds on 15/12/28.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCHeaderView.h"

#import "ZXCAdModel.h"
#import "UIImageView+WebCache.h"

#import "ZXCCommonView.h"

// 下方功能区高度
#define COMMON_HEIGHT 170
// 广告栏定时滚动的时间
#define timer_duration 2

#define BaseTag 987
#define CommonTag 765

@interface ZXCHeaderView ()<UIScrollViewDelegate>
{
    NSArray *_allAds;   // 所有的广告数据
    void (^_clickAction)(ZXCAdModel *);    // 点击广告的回调
    
    NSArray *_allCommons;   // 所有的分类的数据
    void (^_clickCommonAction)(ZXCCommonModel *);   // 点击分类的广告
    
}
/** 广告展示scrollView */
@property (nonatomic, strong) UIScrollView *ads;

/** 下方功能区 */
@property (nonatomic, strong) UIScrollView *common;

/** 广告栏自动滚动计时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 分页控制器 */
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZXCHeaderView

/** 因为在外界, 实例化这个对象的时候, 是用alloc] init]来做的, 所以, 我们只能重写这个方法, 而并不能重写 initWithFrame这个方法 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 在这里, 我们给一个固定的frame即可
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.common.frame));
    }
    return self;
}

#pragma mark ------------- 广告栏相关 -------------------
// 传入所有的广告的数据, 并且提供回调
- (void)setAdsData:(NSArray *)allAds clickCallBack:(void (^)(ZXCAdModel *))click {
    
    // 在添加之前, 先移除原来的内容(因为下拉刷新会重复添加)
    for (UIView *subView in self.ads.subviews) {
        [subView removeFromSuperview];
    }
    
    // 把所有的数据放到一个全局变量中来存储
    _allAds = allAds;
    _clickAction = click;
    
    // 根据分页数据量, 设置分页指示器的页码数量
    self.pageControl.numberOfPages = _allAds.count;
    
    // 遍历allAds数组, 获取所有的广告信息, 展示到界面上即可
    // 添加比需要显示的视图多两个的图片
    for (int i = 0; i < allAds.count + 2; i++) {
        // 获取需要显示的数据模型
        ZXCAdModel *model;
        if (i == 0) {
            model = allAds.lastObject;
        }
        else if (i == allAds.count + 1) {
            model = allAds.firstObject;
        }
        else {
            model = allAds[i - 1];
        }
        
        // 实例化imageView
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, CGRectGetHeight(self.ads.frame))];
        
        // 加载网络图片
        [image sd_setImageWithURL:[NSURL URLWithString:model.image]];
        
        // 给imageView添加点击的手势
        image.userInteractionEnabled = YES;
        
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        
        // 添加tag值, 用来区分不同的imageView
        image.tag = BaseTag + i;
        
        // 添加到广告栏视图上
        [self.ads addSubview:image];
        
        // 设置contentSize
        self.ads.contentSize = CGSizeMake(CGRectGetMaxX(image.frame), 0);
    }
    
    // 设置默认显示第一页
    self.ads.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
    // 设置一个周期后自动执行滚动
    [self.timer performSelector:@selector(setFireDate:) withObject:[NSDate distantPast] afterDelay:timer_duration];
    
    // 将分页指示器提到最前方
    [self bringSubviewToFront:self.pageControl];
}

// 用户点击的事件
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    // 1. 获取当前点击的imageView上显示的是哪一个模型
    NSInteger index = tap.view.tag - BaseTag;
    
    // 2. 根据下标获取模型
    ZXCAdModel *model = [_allAds objectAtIndex:index];
    
    // 3. 事件回调
    if (_clickAction) {
        // 回调, 把model回调回去
        _clickAction(model);
    }
    
}


#pragma mark ----------- 循环滚动相关 -----------
// 开始拖动的时候, 暂停计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}

// 停止拖动的时候, 继续计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate distantPast]];
}

// 减速完成, 手动滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self pageControlWithContentOffset:scrollView.contentOffset.x];
}

// 动画滚动完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self pageControlWithContentOffset:scrollView.contentOffset.x];
}

// 循环滚动相关
- (void)pageControlWithContentOffset:(CGFloat)x {
    
    // 获取当前分页
    NSInteger page = x / SCREEN_WIDTH;
    
    if (page == 0) {
        // 跳转到最后一个需要显示的图片的位置, 即 arr.count
        [self.ads setContentOffset:CGPointMake(SCREEN_WIDTH * _allAds.count, 0) animated:NO];
        self.pageControl.currentPage = _allAds.count - 1;
    }
    else if (page == _allAds.count + 1) {
        // 跳转到第一个需要显示的图片的位置, 即1
        [self.ads setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = page - 1;
    }
}

#pragma mark ---------- 自动滚动 --------------
- (void)runAction {
    CGFloat x = self.ads.contentOffset.x;
    
    [self.ads setContentOffset:CGPointMake(x + SCREEN_WIDTH, 0) animated:YES];
}



#pragma mark ------------------------ 功能区 --------------
- (void)setCommonData:(NSArray *)allData clickCallBacl:(void (^)(ZXCCommonModel *))click {
    
    // 在添加视图前, 先移除原来的视图
    for (UIView *subView in self.common.subviews) {
        
        [subView removeFromSuperview];
    }
    
    // 存储
    _allCommons = allData;
    _clickCommonAction = click;
    
    // 界面布局
    float width = SCREEN_WIDTH / 4.f;
    float height = COMMON_HEIGHT / 2.f;
    for (int i = 0; i < allData.count; i++) {
        //
        ZXCCommonView *comonView = [[ZXCCommonView alloc] initWithFrame:CGRectMake(i % 4 * width, i / 4 * height, width, height)];
        
        // 1. 拿到当前显示的数据
        ZXCCommonModel *model = allData[i];
        
        // 2. 把数据给commonView做展示
        comonView.model = model;
        
        // 3. 添加手势
        comonView.tag = CommonTag + i;
        [comonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommonView:)]];
        
        // 添加到界面上做显示
        [self.common addSubview:comonView];
    }
    
}

// 点击commonView的回调
- (void)tapCommonView:(UITapGestureRecognizer *)tap {
    // 1. 获取当前点击的数据模型
    ZXCCommonModel *model = _allCommons[tap.view.tag - CommonTag];
    
    // 2. 回调
    if (_clickCommonAction) {
        _clickCommonAction(model);
    }
}


- (UIScrollView *)ads {
    if (_ads == nil) {
        // 需要保证图片的宽高比不变
        _ads = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 11 / 32.f)];
        
        // 翻页
        _ads.pagingEnabled = YES;
        
        // 设置代理
        _ads.delegate = self;
        
        // 添加到视图上
        [self addSubview:_ads];
        
    }
    return _ads;
}

- (UIScrollView *)common {
    if (_common == nil) {
        _common = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ads.frame) + 10, SCREEN_WIDTH, COMMON_HEIGHT)];
        
        _common.backgroundColor = [UIColor whiteColor];
        
        // 添加下方功能区
        [self addSubview:_common];
    }
    return _common;
}


- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:timer_duration target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        
        // 
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        
        float width = 100;
        float height = 30;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 10, CGRectGetMaxY(self.ads.frame) - height - 10, width, height)];
        
        _pageControl.currentPageIndicatorTintColor = UIColorRGB(255, 124, 74);
        
        [self addSubview:_pageControl];
    }
    return _pageControl;
}







@end
