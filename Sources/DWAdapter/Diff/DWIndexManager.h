//
//  DWIndexManager.h
//  GDiffExample
//
//  Created by 丁巍 on 2019/4/13.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWIndexManager : NSObject


@property (nonatomic, strong, readonly) NSArray <NSIndexPath *> *inserts;

@property (nonatomic, strong, readonly) NSArray <NSIndexPath *> *deletes;

@property (nonatomic, strong, readonly) NSArray <NSIndexPath *> *updates;


#pragma mark - public method

- (instancetype)initIndexMangerWithInserts:(NSArray *)inserts updates:(NSArray *)updates deletes:(NSArray *)deletes;


@end

NS_ASSUME_NONNULL_END
