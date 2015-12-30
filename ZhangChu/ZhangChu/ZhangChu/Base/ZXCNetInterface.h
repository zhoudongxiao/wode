//
//  ZXCNetInterface.h
//  ZhangChu
//
//  Created by luds on 15/12/28.
//  Copyright © 2015年 luds. All rights reserved.
//

#ifndef ZXCNetInterface_h
#define ZXCNetInterface_h

// 接口
#define BASE_URL @"http://api.izhangchu.com:/"


//网络接口
//所有的接口都是POST请求


//1.首页数据
//URL:http://api.izhangchu.com:/
//参数：
//@{@"methodName": @"HomeIndex"}
//这样拼接:
//http://api.izhangchu.com/?methodName=HomeIndex

#define BASE_URL @"http://api.izhangchu.com:/"

//2.类型二级页面
#define MAIN_URL @"http://api.izhangchu.com:/"
//参数：
//@{@"methodName": @"HomeSerial", @"page": @"1", @"serial_id": @"1", @"size": @"10"}
//这样拼接:
//http://api.izhangchu.com/?methodName=HomeSerial&page=1&serial_id=1&size=10



//3.菜谱详情页
//
//URL：
//http://api.izhangchu.com:/
//
//参数：
//@{@"dishes_id": @"273", @"methodName": @"DishesView"}




#endif /* ZXCNetInterface_h */













