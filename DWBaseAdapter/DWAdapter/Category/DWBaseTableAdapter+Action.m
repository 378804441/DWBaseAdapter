//
//  DWBaseTableAdapter+Action.m
//  tieba
//
//  Created by 丁巍 on 2019/4/8.
//  Copyright © 2019 XiaoChuan Technology Co.,Ltd. All rights reserved.
//

#import "DWBaseTableAdapter+Action.h"

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof__(weakSelf) strongSelf = weakSelf

@implementation DWBaseTableAdapter (Action)

/** 删除cell */
-(void)deleteCellWithIndexPath:(NSIndexPath * __nullable)indexPath indexSet:(NSIndexSet * __nullable)indexSet{
    
    /**
     如果是不分组类型 就算传了indexSet 也会置为空
     如果indexSet 不为空 (分组类型 并且 要删除整个session) 将会给indexPath一个默认值 为了通过断言检测
     */
    DWBaseTableAdapterRowEnum rowType = [self checkRowType];
    if (rowType == DWBaseTableAdapterRow_noGrop) indexSet = nil;
    if (indexSet) indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    WS(weakSelf);
    [self checkDataSourceWithIndexPath:indexPath block:^(DWBaseTableAdapterRowEnum type) {
        SS(strongSelf);
        if (type == DWBaseTableAdapterRow_noGrop) {
            NSInteger deleteLocation = indexPath.row;
            dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
            [self.dataSource removeObjectAtIndex:deleteLocation];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            dispatch_semaphore_signal(strongSelf.semaphore);
        }else if(type == DWBaseTableAdapterRow_grop){
            
            // 删除整个session
            if (indexSet) {
                NSInteger deleteLocation = indexSet.firstIndex;
                dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
                [self.dataSource removeObjectAtIndex:deleteLocation];
                [self.tableView beginUpdates];
                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                dispatch_semaphore_signal(strongSelf.semaphore);
                return ;
            }
            
            // 删除session 里面的某一行
            dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
            
            NSMutableArray * tempArr = [[NSMutableArray alloc] init];
            tempArr = [self.dataSource[indexPath.section] mutableCopy];
            [tempArr removeObjectAtIndex:indexPath.row];
            [self.dataSource replaceObjectAtIndex:indexPath.section withObject:tempArr];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            dispatch_semaphore_signal(strongSelf.semaphore);
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
