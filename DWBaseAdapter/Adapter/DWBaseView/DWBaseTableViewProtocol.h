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

@end
