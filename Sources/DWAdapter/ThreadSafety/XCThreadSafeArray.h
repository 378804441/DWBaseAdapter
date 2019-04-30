//
//  XCThreadSafeArray.h
//  XCChat
//
//  Created by GIKI on 2019/3/12.
//  Copyright © 2019年 xiaochuankeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCThreadSafeArray : NSObject

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
