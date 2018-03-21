//
//  DWBaseTableAdapter.h
//  BaseTableView 适配器
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const DWRowType;

@interface DWBaseTableAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

/** 数据源 */
@property(nonatomic, strong) NSMutableArray *dataSource;

/** 获取 dataSource rowType */
-(NSUInteger)getRowType:(NSArray *)dataSource indexPath:(NSIndexPath *)indexPath;

@end
