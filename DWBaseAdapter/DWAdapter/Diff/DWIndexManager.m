//
//  DWIndexManager.m
//  GDiffExample
//
//  Created by 丁巍 on 2019/4/13.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "DWIndexManager.h"
#import "DWDiffResultIntger.h"

@interface DWIndexManager()

@property (nonatomic, strong, readwrite) NSArray <NSIndexPath *> *inserts;

@property (nonatomic, strong, readwrite) NSArray <NSIndexPath *> *deletes;

@property (nonatomic, strong, readwrite) NSArray <NSIndexPath *> *updates;

@end


@implementation DWIndexManager

#pragma mark - public method

- (instancetype)initIndexMangerWithInserts:(NSArray *)inserts updates:(NSArray *)updates deletes:(NSArray *)deletes{
    self = [super init];
    if (self) {
        NSMutableArray <NSIndexPath *>*insertsM = [NSMutableArray array];
        for (DWDiffResultIntger *diffResult in inserts) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:diffResult.index inSection:diffResult.section];
            [insertsM addObject:indexPath];
        }
        self.inserts = [insertsM copy];
        
        
        NSMutableArray <NSIndexPath *>*updatesM = [NSMutableArray array];
        for (DWDiffResultIntger *diffResult in updates) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:diffResult.index inSection:diffResult.section];
            [updatesM addObject:indexPath];
        }
        self.updates = [updatesM copy];
        
        
        NSMutableArray <NSIndexPath *>*deletesM = [NSMutableArray array];
        for (DWDiffResultIntger *diffResult in deletes) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:diffResult.index inSection:diffResult.section];
            [deletesM addObject:indexPath];
        }
        self.deletes = [deletesM copy];
    }
    return self;
}


@end
