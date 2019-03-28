//
//  ViewAdapterTypeCell1.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterTypeCell1.h"

@implementation ViewAdapterTypeCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


+(float)getAutoCellHeightWithModel:(id)cellModel{
    CGFloat height = [cellModel floatValue];
    return height;
}


@end
