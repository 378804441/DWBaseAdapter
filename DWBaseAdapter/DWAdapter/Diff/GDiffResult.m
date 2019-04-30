//
//  GDiffResult.m
//  GDiffExample
//
//  Created by GIKI on 2018/3/12.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GDiffResult.h"

@interface GDiffResult()

@property (nonatomic, strong, readwrite) NSArray  *Inserts;
@property (nonatomic, strong, readwrite) NSArray  *Deletes;
@property (nonatomic, strong, readwrite) NSArray  *Updates;
@property (nonatomic, strong, readwrite) NSArray<GDiffMoveItem*>  *Moves;

@end

@implementation GDiffResult
- (instancetype)initWithInserts:(NSArray *)inserts
                        deletes:(NSArray *)deletes
                        updates:(NSArray *)updates
                          moves:(NSArray<GDiffMoveItem *> *)moves
                oldIndexPathMap:(NSMapTable<id<NSObject>, NSNumber *> *)oldIndexPathMap
                newIndexPathMap:(NSMapTable<id<NSObject>, NSNumber *> *)newIndexPathMap
{
    self = [super init];
    if (self) {
        self.Inserts = inserts.copy;
        self.Moves = moves.copy;
        self.Deletes = deletes.copy;
        self.Updates = updates.copy;
    }
    return self;
}
@end
