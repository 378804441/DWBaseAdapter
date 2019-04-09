//
//  ViewAdapterTypeCell4.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell4.h"

@implementation ViewAdapterTypeCell4
@synthesize myDelegate = _myDelegate;


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ViewAdapterTypeCell4";
    ViewAdapterTypeCell4 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ViewAdapterTypeCell4 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightTextColor];
    }
    return self;
}


#pragma mark - cell protocol

-(void)bindWithCellModel:(id)cellModel indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = cellModel;
    NSString *text = dataDic[@"text"];
    self.textLabel.text = text;
    self.textLabel.font = [UIFont systemFontOfSize:12];
}

+(float)getAutoCellHeight{
    return 44;
}

#pragma mark - delegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.myDelegate respondsToSelector:@selector(cell4_clickDelegate)]) {
        [self.myDelegate cell4_clickDelegate];
    }
}

@end
