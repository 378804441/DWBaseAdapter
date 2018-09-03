//
//  UserAdapter.m
//  适配器模式
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "UserAdapter.h"
#import "test3Cell.h"
#import "testCell2.h"

@implementation UserAdapter

//初始化DataSource
-(NSMutableArray *)instanceDataSource{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@{DWRowType:@(textType)}];
    [array addObject:@{DWRowType:@(nameType)}];
    [array addObject:@{DWRowType:@(nameType)}];
    [array addObject:@{DWRowType:@(textType)}];
    [array addObject:@{DWRowType:@(textType)}];
    [array addObject:@{DWRowType:@(nameType)}];
    [array addObject:@{DWRowType:@(textType)}];
    [array addObject:@{DWRowType:@(nameType)}];
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModelEnum type = [self getRowType:self.dataSource indexPath:indexPath];
    
    if (type == textType) {
        test3Cell *cell = [test3Cell cellWithTableView:tableView];
        return cell;
    }else{
        testCell2 *cell = [testCell2 cellWithTableView:tableView];
        return cell;
    }
}



@end
