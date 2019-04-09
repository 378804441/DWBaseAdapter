//
//  DWBaseTableViewProtocol.h
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/22.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWBaseTableViewProtocol <NSObject>

/***  必须实现方法 ***/

@optional /***  可以不实现方法 ***/


/** 点击协议 */
-(void)didSelectTableView:(UITableView *)tabView indexPath:(NSIndexPath *)indexPath adapter:(id)adapter;


/**
 刷新tableView协议
 @param indexSet  刷新section
 @param indexPath 刷新cell
 @param adapter   适配器
 */
-(void)reloadTableViewWithIndexSet:(NSIndexSet *)indexSet indexPath:(NSIndexPath *)indexPath adapter:(id)adapter;


/**
 adapter        发起跳转协议
 @param vc      跳转的VC
 @param adapter 适配器
 */
-(void)pushViewController:(UIViewController *)vc adapter:(id)adapter;


/**
 adapter        发起出栈协议
 @param index   指定返回index
 @param adapter 适配器
 */
-(void)popToViewController:(NSInteger)index adapter:(id)adapter;


/**
 跳转到上一页
 */
-(void)popViewController;


/**
 pop 返回到指定页面
 @param vcName  页面名称
 @param dataDic 传递数据
 */
-(void)popToViewController:(NSString *)vcName dataDic:(NSDictionary *)dataDic;


/**
 scrollView         滑动delegate
 @param scrollView  scrollView
 @param adapter     适配器
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView adapter:(id)adapter;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView adapter:(id)adapter;

@end
