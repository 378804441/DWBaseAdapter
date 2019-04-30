//
//  XCThreadSafeDictionary.h
//  XCChat
//
//  Created by GIKI on 2019/3/12.
//  Copyright © 2019年 xiaochuankeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCThreadSafeDictionary : NSObject

+ (instancetype)dictionary;

- (NSDictionary*)getDictionary;

- (NSUInteger)count;

- (NSArray*)allKeys;

- (NSArray*)allValues;

- (NSArray *)popAllValues;

- (__kindof id)objectForKey:(NSString*)key;

- (void)setObject:(id)value forKey:(NSString *)key;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
@end
