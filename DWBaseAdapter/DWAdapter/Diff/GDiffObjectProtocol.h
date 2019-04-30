//
//  GDiffObjectProtocol.h
//  GDiffExample
//
//  Created by GIKI on 2018/3/11.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDiffObjectProtocol <NSObject>

/** indexpath row */
@property (nonatomic, assign) NSInteger index;

/** indexpath section */
@property (nonatomic, assign) NSInteger section;

- (nonnull id<NSObject>)diffIdentifier;

- (BOOL)isEqual:(nullable id<GDiffObjectProtocol>)object;

@end
