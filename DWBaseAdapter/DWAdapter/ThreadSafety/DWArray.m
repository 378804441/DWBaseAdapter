//
//  DWArray.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/4/27.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWArray.h"

@interface DWArray()

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation DWArray

+ (instancetype)array{
    DWArray * array = [[DWArray alloc] init];
    return array;
}

- (instancetype)init{
    if (self = [super init]) {
        self.array = [NSMutableArray array];
        self.lock  = [[NSLock alloc] init];
    }
    return self;
}

- (NSArray *)allObjects{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    NSArray * array = self.array.copy;
    [self.lock unlock];
    return array;
}

- (NSArray *)popAllObjects{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    NSArray * array = self.array.copy;
    [self.array removeAllObjects];
    [self.lock unlock];
    return array;
}

- (NSUInteger)count{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    
    NSUInteger num = self.array.count;
    
    [self.lock unlock];
    return num;
}

- (BOOL)containsObject:(id)anObject{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    BOOL tf = [self.array containsObject:anObject];
    [self.lock unlock];
    return tf;
}

- (id)objectAtIndex:(NSUInteger)index;{
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


- (void)addObject:(id)object{
    if (!object) return;
    
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    [self.array addObject:object];
    
    [self.lock unlock];
}


- (void)removeObject:(id)object{
    if (!object) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.array removeObject:object];
    
    [self.lock unlock];
}


- (void)removeAllObject{
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.array removeAllObjects];
    
    [self.lock unlock];
}

- (void)iterateWitHandler:(BOOL(^)(id element))handler{
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
