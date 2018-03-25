//
//  NewUserAdapter.m
//  适配器模式
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "NewUserAdapter.h"
#import "testCell.h"
#import "testCell2.h"

@implementation NewUserAdapter

//初始化DataSource
-(NSMutableArray *)instanceDataSource{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@[@{DWRowType:@(NewTextType)}]];
    [array addObject:@[@{DWRowType:@(NewNameType)}]];
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NewUserModelEnum type = [self getRowType:self.dataSource indexPath:indexPath];
    if (type == NewTextType) {
        testCell *cell = [testCell cellWithTableView:tableView];
        cell.textLabel.text = @"用户姓名222";
        return cell;
    }else{
        testCell2 *cell = [testCell2 cellWithTableView:tableView];
        cell.textLabel.text = @"用户昵称222";
        return cell;
    }
}



@end
