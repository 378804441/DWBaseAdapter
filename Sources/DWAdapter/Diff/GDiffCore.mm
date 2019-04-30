//
//  GDiffCore.m
//  GDiffExample
//
//  Created by GIKI on 2018/3/11.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GDiffCore.h"
#import <stack>
#import <unordered_map>
#import <vector>

#import "GDiffObjectProtocol.h"
#import "GDiffMoveItem.h"
#import "GDiffResult.h"
#import "DWDiffResultIntger.h"
#import "DWBaseTableAdapter.h"


using namespace std;

struct GDiffEntry {
    NSInteger index      = 0;
    NSInteger section    = 0;
    NSInteger oldCounter = 0;
    NSInteger newCounter = 1;
    stack<NSInteger> oldIndexs;
    BOOL update = NO;
};

struct GDiffRecord {
    GDiffEntry *entry;
    mutable NSInteger index;
    
    GDiffRecord() {
        entry = NULL;
        index = NSNotFound;
    }
};

struct GDiffEqualID {
    bool operator()(const id a, const id b) const {
        return (a == b) || [a isEqual: b];
    }
};

struct GDiffHashID {
    size_t operator()(const id o) const {
        return (size_t)[o hash];
    }
};

static id<NSObject>  GDiffTableKey(id<GDiffObjectProtocol> object) {
    id<NSObject> key = [object diffIdentifier];
    return key;
}

/** 获取分组 */
static NSInteger GDiffTableSction(id<GDiffObjectProtocol> object) {
    return object.section;
}

/** 获取row */
static NSInteger GDiffTableRow(id<GDiffObjectProtocol> object) {
    return object.index;
}



/** 检查 */
static DWBaseTableAdapterRowEnum checkDatasource (NSArray *array){
    if(array.count > 0){
        if([[array lastObject] isKindOfClass:[NSArray class]]
           || [[array lastObject] isKindOfClass:[NSMutableArray class]]){ //分组类型
            return DWBaseTableAdapterRow_grop;
        }else{
            return DWBaseTableAdapterRow_noGrop;
        }
    }
    return DWBaseTableAdapterRow_normal;
}

/** 二维数组进行拍平并进行标识 */
static id conversionArray(NSArray <NSArray *>*array){
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSArray *subArray = array[i];
        for (int j=0; j<subArray.count; j++) {
            id <GDiffObjectProtocol>model = subArray[j];
            model.index   = j;
            model.section = i;
            [arrayM addObject:model];
        }
    }
    return [arrayM copy];
}


static id GDiffProcessor (NSArray *oldArray,
                          NSArray *newArray,
                          GDiffOption option) {
    
    DWBaseTableAdapterRowEnum oldType = checkDatasource(oldArray);
    DWBaseTableAdapterRowEnum newType = checkDatasource(newArray);
    NSString *errorStr = @"新数据源数组与旧数据源数组类型不匹配 (一二维数组不一致)";
    NSCAssert(oldType == newType, errorStr);
    
    // 分组类型进行数组拍平操作
    if (oldType == DWBaseTableAdapterRow_grop ) {
        oldArray = conversionArray(oldArray);
        newArray = conversionArray(newArray);
    }
    
    NSInteger oldCount = oldArray.count;
    NSInteger newCount = newArray.count;
    
    unordered_map<id<NSObject>, GDiffEntry, GDiffHashID, GDiffEqualID> table;
    
    /// 1.为newarray中的每个数据创建一个diffEntry
    vector<GDiffRecord> newResultsArray(newCount);
    for (NSInteger i = 0; i < newCount; i++) {
        id<NSObject> key  = GDiffTableKey(newArray[i]);
        NSInteger section = GDiffTableSction(newArray[i]);
        NSInteger index   = GDiffTableRow(oldArray[i]);
        GDiffEntry &entry = table[key];
        entry.section     = section;
        entry.index       = index;
        entry.newCounter++;
        entry.oldIndexs.push(NSNotFound);
        
        newResultsArray[i].entry = &entry;
    }
    
    // 2,为oldArray中的数据 更新或者新建diffEntry
    vector<GDiffRecord> oldResultsArray(oldCount);
    for (NSInteger i = 0; i < oldCount; i++) {
        id<NSObject> key  = GDiffTableKey(oldArray[i]);
        NSInteger section = GDiffTableSction(oldArray[i]);
        NSInteger index   = GDiffTableRow(oldArray[i]);
        GDiffEntry &entry = table[key];
        entry.section     = section;
        entry.index       = index;
        entry.oldCounter++;
        entry.oldIndexs.push(i);
        oldResultsArray[i].entry = &entry;
    }
    
    /// 3.在一个数组中处理i
    for (NSInteger i = 0; i<newCount; i++) {
        GDiffEntry *entry = newResultsArray[i].entry;
        
        NSCAssert(!entry->oldIndexs.empty(), @"Old indexes is empty while iterating new item %zi. Should have NSNotFound", i);
        const NSInteger originalIndex = entry->oldIndexs.top();
        entry->oldIndexs.pop();
        
        if (originalIndex < oldCount) {
            const id<GDiffObjectProtocol> newTemp = newArray[i];
            const id<GDiffObjectProtocol> oldTemp = oldArray[originalIndex];
            switch (option) {
                case GDiffOptionEquality:
                    if (![newTemp isEqual:oldTemp]) {
                        entry->update = YES;
                    }
                    break;
                    
                case GDiffOptionPointerPersonality:
                    
                    if (newTemp != oldTemp) {
                        entry->update = YES;
                    }
                    break;
                default:
                    break;
            }
            
            if (originalIndex != NSNotFound
                && entry->newCounter > 0
                && entry->oldCounter > 0) {
                //如果项目出现在新数组和旧数组中，则它是唯一的
                //将新记录和旧记录的索引分配给相反的索引(反向查找)
                newResultsArray[i].index = originalIndex;
                oldResultsArray[originalIndex].index = i;
            }
        }
    }
    
    id Inserts = [NSMutableArray new];
    id Moves   = [NSMutableArray new];
    id Updates = [NSMutableArray new];
    id Deletes = [NSMutableArray new];
    
    void (^addIndexToCollection)(id, NSInteger, id, NSInteger, NSInteger) = ^(id collection, NSInteger index, id obj, NSInteger section, NSInteger row) {
        if (obj) {
            [collection addObject:obj];
        }  else {
            DWDiffResultIntger *resultIntger = [[DWDiffResultIntger alloc] init];
            [resultIntger initResultIntgerWithIndex:row section:section];
            [collection addObject:resultIntger];
        }
    };
    NSMapTable *oldMap = [NSMapTable strongToStrongObjectsMapTable];
    NSMapTable *newMap = [NSMapTable strongToStrongObjectsMapTable];
    
    void (^addIndexToMap)(NSInteger, NSArray *, NSMapTable *) = ^(NSInteger index, NSArray *array, NSMapTable *map) {
        id value = @(index);
        [map setObject:value forKey:[array[index] diffIdentifier]];
    };
    
    vector<NSInteger> deleteOffsets(oldCount), insertOffsets(newCount);
    NSInteger runningOffset = 0;
    
    // 重复检查删除旧数组记录
    for (NSInteger i = 0; i < oldCount; i++) {
        deleteOffsets[i] = runningOffset;
        const GDiffRecord record = oldResultsArray[i];
        
        if (record.index == NSNotFound) {
            addIndexToCollection(Deletes, i, nil, record.entry->section, record.entry->index);
            runningOffset++;
        }
        
        addIndexToMap(i, oldArray, oldMap);
    }
    
    // 重置 已经从插入项
    runningOffset = 0;
    for (NSInteger i = 0; i < newCount; i++) {
        insertOffsets[i] = runningOffset;
        const GDiffRecord record = newResultsArray[i];
        const NSInteger oldIndex = record.index;
        
        if (record.index == NSNotFound) {
            addIndexToCollection(Inserts, i, nil, record.entry->section, record.entry->index);
            runningOffset++;
        } else {
            // updated /and/ moved
            if (record.entry->update) {
                addIndexToCollection(Updates, oldIndex, nil, record.entry->section, record.entry->index);
            }
            
            
            // 计算偏移量和确定其是否有移动
            const NSInteger insertOffset = insertOffsets[i];
            const NSInteger deleteOffset = deleteOffsets[oldIndex];
            if ((oldIndex - deleteOffset + insertOffset) != i) {
                
                DWDiffResultIntger *oldIndexObjc = [DWDiffResultIntger new];
                [oldIndexObjc initResultIntgerWithIndex:oldIndex section:0];
                
                DWDiffResultIntger *newIndexObjc = [DWDiffResultIntger new];
                [newIndexObjc initResultIntgerWithIndex:i section:0];
                
                GDiffMoveItem *move = [[GDiffMoveItem alloc] initWithFrom:oldIndexObjc to:newIndexObjc];
                addIndexToCollection(Moves, NSNotFound, move, 0, 0);
            }
        }
        addIndexToMap( i, newArray, newMap);
    }
    
    NSCAssert((oldCount + [Inserts count] - [Deletes count]) == newCount,
              @"Sanity check failed applying %zi inserts and %zi deletes to old count %zi equaling new count %zi",
              oldCount, [Inserts count], [Deletes count], newCount);
    
    
    return [[DWIndexManager alloc] initIndexMangerWithInserts:Inserts updates:Updates deletes:Deletes];
}



@implementation GDiffCore

- (DWIndexManager *)diff:(NSArray*)oldArray newArray:(NSArray*)newArray{
    return GDiffProcessor(oldArray, newArray, GDiffOptionEquality);
}

@end
