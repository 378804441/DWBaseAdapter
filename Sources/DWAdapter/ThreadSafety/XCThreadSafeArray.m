//
//  XCThreadSafeArray.m
//  XCChat
//
//  Created by GIKI on 2019/3/12.
//  Copyright © 2019年 xiaochuankeji. All rights reserved.
//

#import "XCThreadSafeArray.h"
@interface XCThreadSafeArray ()

@property (nonatomic, strong) NSLock* lock;


@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation XCThreadSafeArray

+ (instancetype)array
{
    XCThreadSafeArray * array = [[XCThreadSafeArray alloc] init];
    return array;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.array = [NSMutableArray array];
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (NSArray *)allObjects
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    NSArray * array = self.array.copy;
    [self.lock unlock];
    return array;
}

- (NSArray *)popAllObjects
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    NSArray * array = self.array.copy;
    [self.array removeAllObjects];
    [self.lock unlock];
    return array;
}

- (NSUInteger)count
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    
    NSUInteger num = self.array.count;
    
    [self.lock unlock];
    return num;
}

- (BOOL)containsObject:(id)anObject
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    BOOL tf = [self.array containsObject:anObject];
    [self.lock unlock];
    return tf;
}

- (id)objectAtIndex:(NSUInteger)index;
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    
    if (self.array.count <= index) {
        [_lock unlock];
        return nil;
    }
    id object = [self.array objectAtIndex:index];
    
    [_lock unlock];
    
    return object;
}


- (void)addObject:(id)object
{
    if (!object) return;
    
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    [self.array addObject:object];
    
    [self.lock unlock];
}


- (void)removeObject:(id)object
{
    if (!object) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.array removeObject:object];
    
    [self.lock unlock];
}


- (void)removeAllObject
{
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.array removeAllObjects];
    
    [self.lock unlock];
}

- (void)iterateWitHandler:(BOOL(^)(id element))handler
{
    if (!handler) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    for (id element in self.array) {
        BOOL result = handler(element);
        
        if (result) {
            break;
        }
    }
    
    handler = nil;
    
    [_lock unlock];
}

@end
