//
//  DWIocComponent.h
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/11.
//  Copyright © 2019 丁巍. All rights reserved.
//

//  控制反转组件

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^methodResultBlock)(id __nullable returnObj);

@interface DWIocComponent : NSObject


/** 获取对象 */
+(id)getInstanceByClassName:(NSString *)className;


/**
 方法调用
 methodClass  : 实例对象
 functionName : 方法名称
 objects      : 方法参数(顺序执行)
 
 return       : 方法调用返回值
 */
+(id)methodCallWithMethodClass:(id)methodClass functionName:(NSString *)functionName objects:(NSArray *__nullable)objects;


@end

NS_ASSUME_NONNULL_END
