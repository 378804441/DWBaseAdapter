//
//  DWArray.h
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/4/27.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWArray : NSObject

+ (instancetype)array;

- (NSUInteger)count;

- (NSArray *)allObjects;

- (id)objectAtIndex:(NSUInteger)index;

- (BOOL)containsObject:(id)anObject;

- (void)addObject:(id)object;

- (void)removeObject:(id)object;

- (void)removeAllObject;

- (NSArray *)popAllObjects;

- (void)iterateWitHandler:(BOOL(^)(id element))handler;

@end

NS_ASSUME_NONNULL_END
