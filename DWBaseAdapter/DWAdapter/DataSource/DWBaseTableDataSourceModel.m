//
//  DWBaseTableDataSourceModel.m
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/23.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWBaseTableDataSourceModel.h"

@implementation DWBaseTableDataSourceModel

+ (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell{
    return [[self alloc] initWithTag:tag data:data cell:cell delegate:nil];
}

/** 初始化model */
+ (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell delegate:(id)delegate{
    return [[self alloc] initWithTag:tag data:data cell:cell delegate:delegate];
}

- (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell delegate:(id)delegate{
    self = [super init];
    if (self) {
        self.tag  = tag;
        if (data) {
            self.data = data;
        }
        if (cell) {
            self.cell = cell;
        }
        self.myDelegate = delegate;
    }
    return self;
}

@end
