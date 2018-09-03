//
//  DWBaseTableViewCell.h
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/22.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWBaseTableViewCell : UITableViewCell

//初始化
+(instancetype)cellWithTableView:(UITableView *)tableView;

/** 获取cell高度 */
-(float)getAutoCellHeight;

@end
