//
//  ViewAdapterTypeCell1.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell1.h"

@implementation ViewAdapterTypeCell1


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ViewAdapterTypeCell1";
    ViewAdapterTypeCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ViewAdapterTypeCell1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


+(float)getAutoCellHeightWithModel:(id)cellModel{
    CGFloat height = [cellModel floatValue];
    return height;
}


@end
