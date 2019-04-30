//
//  ViewAdapterTypeCell5.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell5.h"

@implementation ViewAdapterTypeCell5

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ViewAdapterTypeCell5";
    ViewAdapterTypeCell5 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ViewAdapterTypeCell5 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}


#pragma mark - cell protocol

+(float)getAutoCellHeight{
    return 88;
}


@end
