//
//  DWBaseTableAdapter+Action.m
//  tieba
//
//  Created by 丁巍 on 2019/4/8.
//  Copyright © 2019 XiaoChuan Technology Co.,Ltd. All rights reserved.
//

#import "DWBaseTableAdapter+Action.h"

@implementation DWBaseTableAdapter (Action)


/** 不分组批量删除 */
-(void)deleteCellWithIndexPaths:(NSArray <NSIndexPath *>*)indexPaths{
    
    // 将数据源 拷贝一份Mutable 类型
    NSMutableArray *dataSourceM = [self.dataSource mutableCopy];
    
    // 批量删除
    if (indexPaths) {
        
        DWBaseTableAdapterRowEnum rowType = [self checkRowType];
        
        // 平铺类型
        if (rowType == DWBaseTableAdapterRow_noGrop){
            XCSafeInvokeThread(^{
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                
                // 删除数据源
                for (int i=0; i<indexPaths.count; i++) {
                    NSIndexPath *path = indexPaths[i];
                    [dataSourceM removeObjectAtIndex:path.row-i];
                }
                
                // 删除动画
                self.dataSource = [dataSourceM copy];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                dispatch_semaphore_signal(self.semaphore);
            });
            
            
        // 分组类型
        }else if(rowType == DWBaseTableAdapterRow_grop){
            XCSafeInvokeThread(^{
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                
                // 删除数据源
                BOOL isSetDelete = NO;   // 整个 被删除
                NSInteger deleteSet = 0;
                for (int i=0; i<indexPaths.count; i++) {
                    NSIndexPath *path = indexPaths[i];
                    NSMutableArray *tempArr = [dataSourceM[path.section] mutableCopy];
                    [tempArr removeObjectAtIndex:path.row-i];
                    
                    // section 数据都被删除掉了的话 直接删除scetion
                    if (tempArr.count == 0) {
                        isSetDelete = YES;
                        deleteSet = path.section;
                        [dataSourceM removeObjectAtIndex:path.section];
                    }else{
                        [dataSourceM replaceObjectAtIndex:path.section withObject:tempArr];
                    }
                }
                
                // 删除动画
                self.dataSource = [dataSourceM copy];
                [self.tableView beginUpdates];
                
                if (isSetDelete) {
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:deleteSet];
                    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
                
                [self.tableView endUpdates];
                dispatch_semaphore_signal(self.semaphore);
            });
        }
        
    }
}



/** 删除cell */
-(void)deleteCellWithIndexPath:(NSIndexPath * __nullable)indexPath indexSet:(NSIndexSet * __nullable)indexSet{
    
    /**
     如果是不分组类型 就算传了indexSet 也会置为空
     如果indexSet 不为空 (分组类型 并且 要删除整个session) 将会给indexPath一个默认值 为了通过断言检测
     */
    DWBaseTableAdapterRowEnum rowType = [self checkRowType];
    if (rowType == DWBaseTableAdapterRow_noGrop) indexSet = nil;
    if (indexSet) indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // 将数据源 拷贝一份Mutable 类型
    NSMutableArray *dataSourceM = [self.dataSource mutableCopy];
    
    WS(weakSelf);
    [self checkDataSourceWithIndexPath:indexPath block:^(DWBaseTableAdapterRowEnum type) {
        SS(strongSelf);
        if (type == DWBaseTableAdapterRow_noGrop) {
            
            // 单个删除
            NSInteger deleteLocation = indexPath.row;
            dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
            [dataSourceM removeObjectAtIndex:deleteLocation];
            
            XCSafeInvokeThread(^{
                self.dataSource = [dataSourceM copy];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                dispatch_semaphore_signal(strongSelf.semaphore);
            });
            
        }else if(type == DWBaseTableAdapterRow_grop){
            
            // 删除整个session
            if (indexSet) {
                NSInteger deleteLocation = indexSet.firstIndex;
                dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
                [dataSourceM removeObjectAtIndex:deleteLocation];
                
                XCSafeInvokeThread(^{
                    self.dataSource = [dataSourceM copy];
                    [self.tableView beginUpdates];
                    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
                    [self.tableView endUpdates];
                    dispatch_semaphore_signal(strongSelf.semaphore);
                });
                
                return ;
            }
            
            // 删除session 里面的某一行
            dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
            
            NSMutableArray * tempArr = [[NSMutableArray alloc] init];
            tempArr = [self.dataSource[indexPath.section] mutableCopy];
            [tempArr removeObjectAtIndex:indexPath.row];
            [dataSourceM replaceObjectAtIndex:indexPath.section withObject:tempArr];
            
            XCSafeInvokeThread(^{
                self.dataSource = [dataSourceM copy];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                dispatch_semaphore_signal(strongSelf.semaphore);
            });
            
        }
    }];
}

// 检查是否合法
-(void)checkDataSourceWithIndexPath:(NSIndexPath *)indexPath block:(void(^)(DWBaseTableAdapterRowEnum type))blcok{
    NSParameterAssert(self.tableView);
    NSParameterAssert([indexPath isKindOfClass:[NSIndexPath class]]);
    
    DWBaseTableAdapterRowEnum rowType = [self checkRowType];
    if (rowType == DWBaseTableAdapterRow_noGrop) {
        NSParameterAssert(indexPath && self.dataSource.count > 0 && self.dataSource[indexPath.row] && indexPath.section == 0);
        if (blcok) blcok(rowType);
    }else if(rowType == DWBaseTableAdapterRow_grop){
        NSParameterAssert(indexPath && self.dataSource.count > 0 && self.dataSource[indexPath.section] && self.dataSource[indexPath.section][indexPath.row]);
        if (blcok) blcok(rowType);
    }
}

@end
