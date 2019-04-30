//
//  GDiffMoveItem.h
//  GDiffExample
//
//  Created by GIKI on 2018/3/12.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWDiffResultIntger.h"

@interface GDiffMoveItem : NSObject

#pragma mark - punlic property

@property (nonatomic, assign) DWDiffResultIntger *toIndex;

@property (nonatomic, assign) DWDiffResultIntger *fromIndex;


#pragma mark - public method

- (instancetype)initWithFrom:(DWDiffResultIntger *)from to:(DWDiffResultIntger *)to;

@end
