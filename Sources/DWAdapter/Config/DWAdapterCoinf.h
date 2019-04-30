//
//  DWAdapterCoinf.h
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/4/27.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define IsNull(obj)             (obj == nil || [obj isEqual:[NSNull null]])
#define IsEmpty(str)  (str == nil || ![str respondsToSelector:@selector(isEqualToString:)] || [str isEqualToString:@""])

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof__(weakSelf) strongSelf = weakSelf

/**
 安全线程唤起函数
 */
#ifndef xc_dispatch_queue_async_safe
#define xc_dispatch_queue_async_safe(queue, block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

FOUNDATION_STATIC_INLINE void XCSafeInvokeThread(dispatch_block_t block) {
    xc_dispatch_queue_async_safe(dispatch_get_main_queue(), block)
}

@interface DWAdapterCoinf : NSObject

@end

NS_ASSUME_NONNULL_END
