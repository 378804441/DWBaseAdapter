//
//  ViewAdapterTypeCell3.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell3.h"

@implementation ViewAdapterTypeCell3

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ViewAdapterTypeCell3";
    ViewAdapterTypeCell3 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ViewAdapterTypeCell3 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


#pragma mark - cell protocol

+(float)getAutoCellHeightWithModel:(id)cellModel{
    NSDictionary *dataDic = cellModel;
    CGFloat height = [dataDic[@"height"] floatValue];
    return height;
}

-(void)bindWithCellModel:(id)cellModel indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = cellModel;
    NSString *text = dataDic[@"text"];
    self.textLabel.text = text;
    self.textLabel.font = [UIFont systemFontOfSize:12];
}

@end
