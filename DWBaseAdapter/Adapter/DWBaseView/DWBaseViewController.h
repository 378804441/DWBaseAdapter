//
//  DWBaseViewController.h
//  适配器模式
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 颜色宏 */
#define DWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

/** 自定义log */
#ifdef DEBUG   //开发模式的话 是 打印
#define MYLog(...) NSLog(@"\n{类名}:%s,\n{行数}:%d\n{NSLog}:%@ \n\n", __func__, __LINE__, [NSString stringWithFormat: __VA_ARGS__])
#else //非开发模式
#define MYLog(...)
#endif

@interface DWBaseViewController : UIViewController

/** 是否集成下拉刷新功能 默认 NO */
@property (nonatomic, assign) BOOL refreshBOOL;

/** baseTableView */
@property (nonatomic, strong) UITableView *tableView;

@end
