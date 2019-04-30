//
//  GDiffMoveItem.m
//  GDiffExample
//
//  Created by GIKI on 2018/3/12.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GDiffMoveItem.h"

@implementation GDiffMoveItem

- (instancetype)initWithFrom:(DWDiffResultIntger *)from to:(DWDiffResultIntger *)to{
    self = [super init];
    if (self ) {
        self.fromIndex = from;
        self.toIndex   = to;
    }
    return self;
}

@end
