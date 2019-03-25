//
//  DWBaseTableAdapter.h
//  BaseTableView 适配器
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWBaseTableDataSourceModel.h"
#import "DWBaseTableViewProtocol.h"
#import "DWBaseHandlerProtocol.h"
#import "DWBaseCellProtocol.h"

/** 指定获取dataSourceModel里面字段 */
typedef NS_ENUM(NSInteger, DWBaseTableAdapterRowType){
    DWBaseTableAdapterRowType_rowType = 0,  // Cell类型
    DWBaseTableAdapterRowType_rowData,      // Cell绑定数据
    DWBaseTableAdapterRowType_rowCell,      // Cell类对象
    DWBaseTableAdapterRowType_rowDelegate   // delegate
};

@interface DWBaseTableAdapter : NSObject<UITableViewDataSource, UITableViewDelegate, DWBaseTableViewProtocol, DWBaseHandlerProtocol>

#pragma mark - public property

/** delegate */
@property (nonatomic, weak)   id<DWBaseTableViewProtocol> myDelegate;

/** 注册tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;


#pragma mark - public method

/** 初始化dataSource */
-(NSMutableArray *)instanceDataSource;

/** 获取 指定的dataSource内容 */
-(id)getDataSourceWithSourceArray:(NSArray *)sourceArray indexPath:(NSIndexPath *)indexPath type:(DWBaseTableAdapterRowType)type;

@end
