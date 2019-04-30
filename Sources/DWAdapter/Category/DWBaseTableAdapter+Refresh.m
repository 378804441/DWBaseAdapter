//
//  DWBaseTableAdapter+Refresh.m
//  tieba
//
//  Created by 丁巍 on 2019/4/8.
//  Copyright © 2019 XiaoChuan Technology Co.,Ltd. All rights reserved.
//

#import "DWBaseTableAdapter+Refresh.h"


@implementation DWBaseTableAdapter (Refresh)

/**
 刷新tableView协议
 */
-(void)reloadTableView{
    NSParameterAssert(self.tableView);
    [self reloadTableViewWithIndexSet:nil indexPath:nil];
}

/**
 刷新tableView协议 - 刷新, 清除高度缓存
 */
-(void)reloadTableViewClearCache{
    NSParameterAssert(self.tableView);
    [self clearCache];
    [self reloadTableViewWithIndexSet:nil indexPath:nil];
}


/**
 刷新tableView协议
 @param cell      刷新cell对象
 */
-(void)reloadTableViewWithCell:(UITableViewCell *)cell{
    NSParameterAssert(self.tableView);
    if (IsNull(cell)) return;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self reloadTableViewWithIndexSet:nil indexPath:indexPath];
}

/**
 刷新tableView协议
 @param indexSet  刷新section
 */
-(void)reloadTableViewWithIndexSet:(NSIndexSet *)indexSet{
    NSParameterAssert(self.tableView);
    [self reloadTableViewWithIndexSet:indexSet indexPath:nil];
}

/**
 刷新tableView协议
 @param indexPath 刷新row
 */
-(void)reloadTableViewWithIndexPath:(NSIndexPath *)indexPath{
    NSParameterAssert(self.tableView);
    [self reloadTableViewWithIndexSet:nil indexPath:indexPath];
}

/**
 刷新tableView协议
 @param indexSet  刷新section
 @param indexPath 刷新row
 */
-(void)reloadTableViewWithIndexSet:(NSIndexSet *__nullable)indexSet indexPath:(NSIndexPath * __nullable)indexPath{
    NSParameterAssert(self.tableView);
    if (indexSet) {
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if(indexPath){
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView reloadData];
    }
}


@end
