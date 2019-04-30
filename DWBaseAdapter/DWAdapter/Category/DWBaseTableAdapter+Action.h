//
//  DWBaseTableAdapter+Action.h
//  tieba
//
//  Created by 丁巍 on 2019/4/8.
//  Copyright © 2019 XiaoChuan Technology Co.,Ltd. All rights reserved.
//
//
//  所有 操作

#import "DWBaseTableAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface DWBaseTableAdapter (Action)

/** 不分组批量删除 */
-(void)deleteCellWithIndexPaths:(NSArray <NSIndexPath *>*)indexPaths;

/** 删除cell */
-(void)deleteCellWithIndexPath:(NSIndexPath * __nullable)indexPath indexSet:(NSIndexSet * __nullable)indexSet;


@end

NS_ASSUME_NONNULL_END
