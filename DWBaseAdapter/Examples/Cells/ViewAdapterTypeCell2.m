//
//  ViewAdapterTypeCell2.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell2.h"
#import "CellModel2.h"

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
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}


#pragma mark - cell protocol

+(float)getAutoCellHeightWithModel:(id)cellModel{
    CellModel2 *dataDic = cellModel;
    return dataDic.height;
}

-(void)bindWithCellModel:(id)cellModel indexPath:(NSIndexPath *)indexPath{
    CellModel2 *dataDic = cellModel;
    NSString *text = dataDic.title;
    self.textLabel.text = text;
    self.textLabel.font = [UIFont systemFontOfSize:12];
}


@end
