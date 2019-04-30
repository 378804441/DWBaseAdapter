//
//  GDiffResult.h
//  GDiffExample
//
//  Created by GIKI on 2018/3/12.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GDiffMoveItem;
@interface GDiffResult : NSObject
@property (nonatomic, strong, readonly) NSArray  *Inserts;
@property (nonatomic, strong, readonly) NSArray  *Deletes;
@property (nonatomic, strong, readonly) NSArray  *Updates;
@property (nonatomic, strong, readonly) NSArray<GDiffMoveItem*>  *Moves;

- (instancetype)initWithInserts:(NSArray *)inserts
                        deletes:(NSArray *)deletes
                        updates:(NSArray *)updates
                          moves:(NSArray<GDiffMoveItem *> *)moves
                oldIndexPathMap:(NSMapTable<id<NSObject>, NSNumber *> *)oldIndexPathMap
                newIndexPathMap:(NSMapTable<id<NSObject>, NSNumber *> *)newIndexPathMap;
@end
