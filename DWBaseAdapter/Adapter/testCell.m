//
//  testCell.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/23.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "testCell.h"

@interface testCell()


@end

@implementation testCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

//初始化
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"testCell";
    testCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[testCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//cell的初始化方法  一个cell只会调用一次
//在这里一般添加所有可能显示的子控件, 以及子空间的一次性设置
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
//        testCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"testCell" owner:nil options:nil] lastObject];
//        cell.frame = CGRectMake(0, 0, self.contentView.frame.size.width, [self getAutoCellHeight]);
//        [self.contentView addSubview:cell];
    }
    return self;
}


/** 获取cell高度 */
-(float)getAutoCellHeight{
    return 100;
}

@end
