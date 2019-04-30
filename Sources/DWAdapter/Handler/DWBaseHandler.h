//
//  DWBaseHandler.h
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/11.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWBaseHandler : NSObject

#pragma mark - public method

/** 初始化handler */
- (instancetype)initWithController:(id)controller adapter:(id)adapter;

/** 删除绑定在该 handler上的 observer */
- (void)removeObservers;


#pragma mark - public property

/** 控制器里的处理事件 */
@property (nonatomic, weak) id controler;

/** 适配器里面的处理事件 */
@property (nonatomic, weak) id adapter;

@end

NS_ASSUME_NONNULL_END
