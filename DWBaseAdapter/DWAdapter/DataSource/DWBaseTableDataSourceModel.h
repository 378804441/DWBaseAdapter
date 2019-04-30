//
//  DWBaseTableDataSourceModel.h
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/23.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDiffObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DWBaseTableDataSourceModel : NSObject<GDiffObjectProtocol>


#pragma mark - public property

/** Cell 标注 (rowType) */
@property (nonatomic, assign) NSInteger tag;

/** Cell 绑定数据源 (rowData) */
@property (nonatomic, strong) id data;

/** Cell 类对象 (rowCell) */
@property (nonatomic, strong) id cell;

/** delegate */
@property (nonatomic, weak)   id myDelegate;

/** 哈希地址 */
@property (nonatomic, strong, readonly) NSString *modelHash;



#pragma mark - public method

/** 初始化model */
+ (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell;

/** 初始化model */
+ (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell delegate:(id)delegate;


#pragma mark - diff Protocol

/** 唯一标识符 */
- (nonnull id<NSObject>)diffIdentifier;

/** 当前model什么字段发生改变时候需要diff计算 */
- (BOOL)isEqual:(nullable id<GDiffObjectProtocol>)object;

@end

NS_ASSUME_NONNULL_END
