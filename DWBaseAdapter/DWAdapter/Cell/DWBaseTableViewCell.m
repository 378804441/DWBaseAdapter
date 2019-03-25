//
//  DWBaseTableViewCell.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/22.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "DWBaseTableViewCell.h"
#import <objc/runtime.h>

@implementation DWBaseTableViewCell
@synthesize myDelegate = _myDelegate;

//初始化
+(instancetype)cellWithTableView:(UITableView *)tableView{
    return nil;
}

/** 获取cell高度 */
+(float)getAutoCellHeight{
    return 44;
}

@end
