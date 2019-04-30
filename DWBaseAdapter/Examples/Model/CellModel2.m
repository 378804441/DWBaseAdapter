//
//  CellModel2.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/4/29.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "CellModel2.h"

@interface CellModel2()<NSCopying>

@end

@implementation CellModel2
@synthesize index   = _index;
@synthesize section = _section;

#pragma mark - diff Protocol

/** 唯一标识符 */
- (nonnull id<NSObject>)diffIdentifier {
    return  self;
}

/** 当前model什么字段发生改变时候需要diff计算 */
- (BOOL)isEqual:(nullable id<GDiffObjectProtocol>)object {
    return [((CellModel2 *)object).title isEqualToString:self.title];
}


-(id)copyWithZone:(NSZone *)zone{
    CellModel2 *copyObj = [CellModel2 new];
    copyObj.title = self.title;
    return copyObj;
}

@end
