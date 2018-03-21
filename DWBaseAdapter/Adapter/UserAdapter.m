//
//  UserAdapter.m
//  适配器模式
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "UserAdapter.h"

@implementation UserAdapter

//初始化DataSource
-(NSMutableArray *)instanceDataSource{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@{DWRowType:@(textType)}];
    [array addObject:@{DWRowType:@(nameType)}];
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModelEnum type = [self getRowType:self.dataSource indexPath:indexPath];
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }
    
    if (type == textType) {
        cell.textLabel.text = @"用户姓名";
    }else if(type == nameType){
        cell.textLabel.text = @"用户昵称";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.myDelegate respondsToSelector:@selector(didSelectTableView: indexPath:)]) {
        [self.myDelegate didSelectTableView:tableView indexPath:indexPath];
    }
}


@end
