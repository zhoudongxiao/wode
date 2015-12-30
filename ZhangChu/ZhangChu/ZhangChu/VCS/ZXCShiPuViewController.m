//
//  ZXCShiPuViewController.m
//  ZhangChu
//
//  Created by luds on 15/12/28.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "ZXCShiPuViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "ZXCHeaderView.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#import "ZXCAdModel.h"
#import "ZXCCommonModel.h"
#import "ZXCIndexModel.h"
#import "PageModel.h"

#import "ZXCVideoTableViewCell.h"
#import "ZXCRecommendTableViewCell.h"
#import "ZXCNewTableViewCell.h"



#define cell_identifier_video @"videoCell"
#define cell_identifier_recommend @"recommendCell"
#define cell_identifier_new @"newCell"

@interface ZXCShiPuViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 界面展示 */
@property (nonatomic, strong) UITableView *tableView;

/** 全局数组, 用来存放分组的数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
//存放分页上的数据
@property (nonatomic, strong) NSMutableArray *pageSource;

/** 头视图, 包含广告和功能区 */
@property (nonatomic, strong) ZXCHeaderView *headerView;

@end

@implementation ZXCShiPuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

#pragma mark -------- 加载数据 ----------------
/** 加载数据 */
- (void)loadData {
    
    // 加载上部数据
    [self loadMainData];
    
}
/** 加载上部数据 */
- (void)loadMainData {
    // 加载全部数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 请求
    [manager POST:BASE_URL parameters:@{@"methodName": @"HomeIndex"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 请求成功, 解析数据
        // 1. 解析广告栏相关
        [self parseAd:responseObject];
        
        // 2. 解析功能区相关的数据
        [self parseCommon:responseObject];
        
        // 3. 解析所有用到的信息
        [self parseData:responseObject];
        
        [self doneLoadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self doneLoadData];
    }];
}

-(void)loadPageData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:MAIN_URL parameters:@{@"methodName": @"HomeSerial", @"page": @"1", @"serial_id": @"1", @"size": @"10"} success:^(AFHTTPRequestOperation *  operation, id responseObject) {
        //请求成功,解析
        [self parsePageData:responseObject];
        
    } failure:^ (AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
    
}
/** 数据加载完成 */
- (void)doneLoadData {
    // 1. 停止下拉刷新
    [self.tableView.header endRefreshing];
}


#pragma mark --------- 解析数据 ---------------
-(void)parsePageData:(NSDictionary *)data{
    //1.
    NSArray *allData = data[@"data"][@"data"];
    for (NSDictionary *dic in allData) {
        PageModel *model = [[PageModel alloc] initWithDictionary:dic error:nil];
        
        //存到分页数组中
        [self.pageSource addObject:model];
    }

    
    
}
/** 3. 解析所有用到的信息 */
- (void)parseData:(NSDictionary *)data {
    // 存放所有分组信息的数组
    NSArray *allData = data[@"data"][@"data"];
    
    // 把数组中的每一个字典, 转成想要的模型即可
    for (NSDictionary *info in allData) {
        
        // 分组模型
        ZXCIndexModel *model = [[ZXCIndexModel alloc] initWithDictionary:info error:nil];
        
        // 添加到数据源数组中
        [self.dataSource addObject:model];
    }
    
    // 刷表
    [self.tableView reloadData];
}
/** 2. 功能区相关数据解析 */
- (void)parseCommon:(NSDictionary *)data {
    // 1. 获取存放所有功能显示模块相关的数据
    NSArray *allData = data[@"data"][@"category"][@"data"];
    
    // 临时存储所有的模型
    NSMutableArray *allModels = [NSMutableArray array];
    
    // 2. 遍历数组, 把所有的字典, 转成需要的模型
    for (NSDictionary *info in allData) {
    
        // 字典转模型
        ZXCCommonModel *model = [[ZXCCommonModel alloc] initWithDictionary:info error:nil];
        
        [allModels addObject:model];
    }
    
    // 设置所有的数据, 并设置点击的回调
    [self.headerView setCommonData:allModels clickCallBacl:^(ZXCCommonModel *model) {
        // 这里是点击分类的回调
        NSLog(@"%@", model.text);
    }];
}

/** 1. 广告栏相关 */
- (void)parseAd:(NSDictionary *)data {
    // 1. 获取存放所有广告信息的数组
    NSArray *allAds = data[@"data"][@"banner"][@"data"];
    
    // 2. 遍历数组, 把字典转成模型
    NSMutableArray *ads = [[NSMutableArray alloc] init];
    
    for (NSDictionary *info in allAds) {
        // 字典转模型
        ZXCAdModel *model = [[ZXCAdModel alloc] initWithDictionary:info error:nil];
        
        // 添加到数组中做存储
        [ads addObject:model];
    }
    
    // 3. 把数据给headerView做界面展示
    [self.headerView setAdsData:ads clickCallBack:^(ZXCAdModel *model) {
        NSLog(@"%@", model.link);
    }];
}





#pragma mark ------------- tableView常用协议 --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource.count == 0) {
        return 0;
    }
    return self.dataSource.count +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            // 1. 取出分组model
            ZXCIndexModel *model = self.dataSource[section];
            
            // 2. 返回这个分组model中, data数组的长度
            return model.data.count;
            break;
        }
        case 1: {
            
            return 1;
            break;
        }
        case 4: {
            
            return 1;
            break;
        }

            
        default:
            break;
    }
    return 0;
}

// 每行需要显示什么样的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            // 1. 取cell
            ZXCVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier_video];
            
            // 2. 界面布局
            // 2.1 先取出来需要展示的数据
            ZXCIndexModel *indexModel = self.dataSource[indexPath.section];
            
            ZXCRowModel *model = indexModel.data[indexPath.row];
            
            // 2.2 把数据给cell, 让cell进行界面展示
            cell.model = model;
            
            // 3. 返回cell
            return cell;
        }
        case 1: {
            // 1. 取cell
            ZXCRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier_recommend];
            
            // 界面展示
            ZXCIndexModel *model = self.dataSource[indexPath.section];
            cell.models = model.data;
            
            // 设置点击回调
            [cell setClickCallBack:^(ZXCRowModel * model) {
                [self presentVideoPlayer:model];
            }];
            
            // 返回cell
            return cell;
        }
            
        default:
            break;
    }
    
    return 0;
}




#pragma mark ------------- 刷新集成 ------------
/** 关于下拉刷新 */
- (void)addRefreshControl {
    // 1. 下拉刷新集成
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        // 重新加载数据
        [self loadData];
    }];
    
    // 设置常用的属性
//    [header setTitle:@"松开!" forState:MJRefreshStatePulling];
//    [header setTitle:@"刷啊刷啊刷啊刷" forState:MJRefreshStateRefreshing];
    
    // 2. 添加到tableView上
    self.tableView.header = header;
}

#pragma mark ------------- 懒加载 --------------
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 头视图
        _tableView.tableHeaderView = self.headerView;
        
        // 刷新集成
        [self addRefreshControl];
        
        // 分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 注册cell
        [_tableView registerClass:[ZXCVideoTableViewCell class] forCellReuseIdentifier:cell_identifier_video];
        [_tableView registerClass:[ZXCRecommendTableViewCell class] forCellReuseIdentifier:cell_identifier_recommend];
        [_tableView registerClass:[ZXCNewTableViewCell class] forCellReuseIdentifier:cell_identifier_new];
    }
    
    return _tableView;
}

- (ZXCHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[ZXCHeaderView alloc] init];
    }
    
    return _headerView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}
-(NSMutableArray *)pageSource{
    if (!_pageSource) {
        _pageSource = [[NSMutableArray alloc] init];
    }
    return _pageSource;
}

// 每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            return SCREEN_WIDTH / 2.f + 10;
            break;
        }
        case 1: {
            return (SCREEN_WIDTH - 10 * 2.5) / 3.f + 10;
            break;
        }
        case 4: {
            return (SCREEN_WIDTH - 10 * 2.5) / 3.f + 10;
            break;
        }

            
        default:
            return 0;
    }
}


// 选中某行的回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // 1. 获取rowModel
        ZXCIndexModel *model = self.dataSource[indexPath.section];
        ZXCRowModel *row = model.data[indexPath.row];
        
        // 推出视频
        [self presentVideoPlayer:row];
    }
}

- (void)presentVideoPlayer:(ZXCRowModel *)row {
    // 2. 实例化一个视频播放器
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:row.video]];
    
    // 3. 直接弹出使用即可
    [self presentViewController:movie animated:YES completion:nil];

}

@end
