//
//  ViewAdapterTypeCell2.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell2.h"

@implementation ViewAdapterTypeCell2

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ViewAdapterTypeCell2";
    ViewAdapterTypeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ViewAdapterTypeCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}


#pragma mark - cell protocol

+(float)getAutoCellHeight{
    return 60;
}


@end
