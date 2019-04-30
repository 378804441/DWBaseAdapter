//
//  DWBaseHandlerProtocol.h
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/11.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DWBaseHandlerProtocol <NSObject>


@required   /***  必须实现方法 ***/

@optional   /***  可以不实现方法 ***/

/** 绑定handler */
- (void)configHandler:(id)handler;

@end

NS_ASSUME_NONNULL_END
