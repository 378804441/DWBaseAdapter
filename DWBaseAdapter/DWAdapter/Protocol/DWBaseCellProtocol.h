//
//  DWBaseCellProtocol.h
//  DWVideoPlay
//
//  Created by 丁巍 on 2019/3/22.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DWBaseCellProtocol <NSObject>
@optional

@property(nonatomic, weak) id myDelegate;

/** 初始化 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 获取cell高度 */
+ (float)getAutoCellHeight;

/** 获取cell高度 */
+ (float)getAutoCellHeightWithModel:(id)cellModel;

/** 绑定数据源 */
- (void)bindWithCellModel:(id)cellModel indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
