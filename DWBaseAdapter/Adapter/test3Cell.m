//
//  test3Cell.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/27.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "test3Cell.h"

@interface test3Cell()

@property (weak, nonatomic) IBOutlet UIButton *test;

@end

@implementation test3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//初始化
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"test3Cell";
    test3Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[test3Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
