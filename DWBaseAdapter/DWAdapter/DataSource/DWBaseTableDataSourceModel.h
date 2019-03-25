//
//  DWBaseTableDataSourceModel.h
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/23.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWBaseTableDataSourceModel : NSObject


#pragma mark - public property

/** Cell 标注 (rowType) */
@property (nonatomic, assign) NSInteger tag;

/** Cell 绑定数据源 (rowData) */
@property (nonatomic, strong) id data;

/** Cell 类对象 (rowCell) */
@property (nonatomic, strong) id cell;

/** delegate */
@property (nonatomic, weak) id myDelegate;


#pragma mark - public method

/** 初始化model */
+ (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell;

/** 初始化model */
+ (instancetype)initWithTag:(NSInteger)tag data:(id __nullable)data cell:(id __nullable)cell delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
