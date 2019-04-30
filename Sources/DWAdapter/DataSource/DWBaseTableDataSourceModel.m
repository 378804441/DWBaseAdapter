//
//  DWBaseTableDataSourceModel.m
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/23.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWBaseTableDataSourceModel.h"

@implementation DWBaseTableDataSourceModel
@synthesize section = _section;
@synthesize index   = _index;


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
        _modelHash = [NSString stringWithFormat:@"%lu", (unsigned long)[self hash]];
    }
    return self;
}


#pragma mark - diff Protocol

/** 唯一标识符 */
- (nonnull id<NSObject>)diffIdentifier {
    return  self.modelHash;
}

/** 当前model什么字段发生改变时候需要diff计算 */
- (BOOL)isEqual:(nullable id<GDiffObjectProtocol>)object {
    
    // 判断dataSource 是否实现了 GDiffObjectProtocol 方法
    if (![self.data conformsToProtocol:@protocol(GDiffObjectProtocol)]) {
        return YES;
    }
    
    id <GDiffObjectProtocol>subObjc = self.data;
    DWBaseTableDataSourceModel *objc = (DWBaseTableDataSourceModel *)object;
    BOOL isE = (self.modelHash == objc.modelHash);
    isE = isE && [subObjc isEqual:objc.data];
    return isE;
}

@end
