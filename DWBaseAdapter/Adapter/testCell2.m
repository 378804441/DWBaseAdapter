//
//  testCell2.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/23.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "testCell2.h"

@implementation testCell2

//初始化
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"testCell2";
    testCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[testCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

//cell的初始化方法  一个cell只会调用一次
//在这里一般添加所有可能显示的子控件, 以及子空间的一次性设置
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

/** 获取cell高度 */
-(float)getAutoCellHeight{
    return 100;
}



@end
