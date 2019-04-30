//
//  DWIocComponent.m
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/11.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWIocComponent.h"
#import <objc/runtime.h>

@implementation DWIocComponent

#pragma mark - public method

/** 获取对象 */
+(id)getInstanceByClassName:(NSString *)className{
    if (IsEmpty(className)) return nil;
    id class = [[NSClassFromString(className) alloc] init];
    if (!class) {
        @throw [NSException exceptionWithName:@"Create instance error" reason: @"动态创建对象失败" userInfo: nil];
        return nil;
    }
    return class;
}

/** 方法调用 */
+(id)methodCallWithMethodClass:(id)methodClass functionName:(NSString *)functionName objects:(NSArray *__nullable)objects{
    if (IsNull(methodClass) || IsEmpty(functionName)) return nil;
    
    // 获取该类的方法SEL对象
    SEL methodSEL = [self getMethodSELWithClass:methodClass methodName:functionName];
    if (methodSEL == nil) {
        NSLog(@"%@", @"该方法不存在");
        return nil;
    }
    
    // 通过 performSelector 调用方法
    return [self performSelector:methodClass selector:methodSEL objects:objects];
}


#pragma mark - private method

/** 检查该对象里是否存在该方法 */
+(SEL)getMethodSELWithClass:(id)class methodName:(NSString *)methodName{
    unsigned int mothCout_f =0;
    Method *mothList_f = class_copyMethodList([class class], &mothCout_f);
    for(int i=0;i<mothCout_f;i++){
        Method temp_f = mothList_f[i];
        //IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char *name_s = sel_getName(method_getName(temp_f));
        //        int arguments = method_getNumberOfArguments(temp_f);
        NSString *funName = [NSString stringWithFormat:@"%s", name_s];
        if ([funName isEqualToString:methodName]) {
            return name_f;
        }
    }
    free(mothList_f);
    return nil;
}

/** method 调用 */
+ (id)performSelector:(id)methodClass selector:(SEL)selector objects:(NSArray *)objects{
    NSMethodSignature *methodSignature = [[methodClass class] instanceMethodSignatureForSelector:selector];
    if(methodSignature == nil){
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:methodClass];
    [invocation setSelector:selector];
    //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
    NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
    NSInteger requireParamCount = objects.count;
    NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
    for (NSInteger i = 0; i < resultParamCount; i++) {
        id  obj = objects[i];
        [invocation setArgument:&obj atIndex:i+2];
    }
    [invocation invoke];
    
    //返回值处理
    id callBackObject = nil;
    if(methodSignature.methodReturnLength){
        [invocation getReturnValue:&callBackObject];
    }
    
    return callBackObject;
}


@end
