//
//  NewUserAdapter.m
//  适配器模式
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "NewUserAdapter.h"

@implementation NewUserAdapter

//初始化DataSource
-(NSMutableArray *)instanceDataSource{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@[@{DWRowType:@(NewNameType)}]];
    [array addObject:@[@{DWRowType:@(NewTextType)}]];
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewUserModelEnum type = [self getRowType:self.dataSource indexPath:indexPath];
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }
    
    if (type == NewTextType) {
        cell.textLabel.text = @"用户姓名";
    }else if(type == NewNameType){
        cell.textLabel.text = @"用户昵称";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.myDelegate respondsToSelector:@selector(newUserDidSelectTableView: indexPath:)]) {
        [self.myDelegate newUserDidSelectTableView:tableView indexPath:indexPath];
    }
}

@end
