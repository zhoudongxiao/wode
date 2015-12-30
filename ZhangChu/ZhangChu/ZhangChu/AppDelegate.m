//
//  AppDelegate.m
//  ZhangChu
//
//  Created by luds on 15/12/28.
//  Copyright © 2015年 luds. All rights reserved.
//

#import "AppDelegate.h"

#import "UIImage+ZXCOriginal.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 1. 抽取父类(UIViewController, xxx)
    // 2. 公共配置文件(在这里一般写一些常用的属性/方法)
    
    // 3.
    [self createRootViewController];
    
    
    
    return YES;
}

/** 根视图控制器 */
- (void)createRootViewController {
    
    // 1. 实例化tabBarController
    UITabBarController *tab = [[UITabBarController alloc] init];
    
    // 2. 添加tabBarController的子视图控制器
    NSArray *classNames = @[@"ZXCShiPuViewController",
                            @"ZXCRootViewController",
                            @"ZXCRootViewController",
                            @"ZXCRootViewController"];
    NSArray *titles = @[@"食谱", @"喜欢", @"食课", @"我的"];
    
    // 普通状态和高亮状态的图片名称
    NSArray *imgs = @[@"食谱A", @"喜欢A", @"食课A", @"我的A"];
    NSArray *imgsH = @[@"食谱B", @"喜欢B", @"食课B", @"我的B"];
    
    // 循环添加视图控制器
    for (int i = 0; i < classNames.count; i++) {
        // 根据类名获取类
        Class class = NSClassFromString(classNames[i]);
        // 通过类去实例化视图控制器
        UIViewController *vc = [[class alloc] init];
        // 设置标题
        vc.title = titles[i];
        // 实例化一个导航视图控制器
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        // 设置tabBar相关
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:[UIImage imageNamed:imgs[i]] selectedImage:[UIImage imageNamed:imgsH[i]].originalImage];
        
        // 添加为tabBarController的根视图控制器
        [tab addChildViewController:nav];
        
        // 设置tabBar上的tintColor
        tab.tabBar.tintColor = UIColorRGB(255, 124, 74);
    }
    
    // 把这个tabBarController作为window的根视图控制器
    self.window.rootViewController = tab;
}











@end
