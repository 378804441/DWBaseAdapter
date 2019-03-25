//
//  DWBaseTableViewCell.h
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/22.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWBaseCellProtocol.h"

#define cellW [[UIScreen mainScreen] bounds].size.width

@interface DWBaseTableViewCell : UITableViewCell<DWBaseCellProtocol>

@end
