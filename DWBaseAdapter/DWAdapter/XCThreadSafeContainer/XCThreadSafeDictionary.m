//
//  XCThreadSafeDictionary.m
//  XCChat
//
//  Created by GIKI on 2019/3/12.
//  Copyright © 2019年 xiaochuankeji. All rights reserved.
//

#import "XCThreadSafeDictionary.h"

@interface XCThreadSafeDictionary ()

@property(nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSLock * lock;

@end

@implementation XCThreadSafeDictionary

+ (instancetype)dictionary
{
    XCThreadSafeDictionary * dict = [[XCThreadSafeDictionary alloc] init];
    return dict;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.dict = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

-(void)dealloc
{
    _dict = nil;
    _lock  = nil;
}

- (NSDictionary*)getDictionary
{
    return self.dict.copy;
}

- (NSUInteger)count
{
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    NSUInteger num = [self.dict count];
    
    [_lock unlock];
    
    return num;
}

- (NSArray*)allKeys
{
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    NSArray * allkeys = [self.dict allKeys];
    
    [_lock unlock];
    
    return allkeys;
}

- (NSArray*)allValues
{
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    NSArray * allvalues = [self.dict allValues];
    
    [_lock unlock];
    
    return allvalues;
}

- (NSArray *)popAllValues
{
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    NSArray * allvalues = [self.dict allValues];
    [self.dict removeAllObjects];
    [_lock unlock];
    
    return allvalues;
}

- (__kindof id)objectForKey:(NSString*)key
{
    if (key.length <= 0) {
        return nil;
    }
    
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    id object = [self.dict objectForKey:key];
    
    [_lock unlock];
    
    return object;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    if (otherDictionary!=nil&&[otherDictionary isKindOfClass:[NSDictionary class]]&&[(NSDictionary *)otherDictionary count]>0) {
        while (![_lock tryLock]) {
            usleep(10*1000);
        }
        [self.dict addEntriesFromDictionary:otherDictionary];
        
        [_lock unlock];
    }
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    if (!value || key.length <= 0) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    [self.dict setObject:value forKey:key];
    
    [_lock unlock];
    
}

- (void)removeObjectForKey:(id)key
{
    if (key == nil) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.dict removeObjectForKey:key];
    
    [_lock unlock];
    
}

- (void)removeAllObjects
{
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.dict removeAllObjects];
    
    [_lock unlock];
}

@end
