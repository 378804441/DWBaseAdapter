//
//  DWBaseTableAdapter.m
//  BaseTableView 适配器
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "DWBaseTableAdapter.h"

typedef NS_ENUM(NSInteger, DWBaseTableAdapterRowEnum){
    noGropRowType = 0, //不分组
    gropRowType,        //分组
    dataSourceNormal //数据源为空
};

NSString *const DWRowType = @"DWRowType"; //储存tableView时候的key

@implementation DWBaseTableAdapter

#pragma mark - 初始化DataSource方法
//数据源初始化
-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [self instanceDataSource];
    }
    return _dataSource;
}

-(NSMutableArray *)instanceDataSource{
    NSMutableArray *array = [NSMutableArray array];
    return array;
}

#pragma mark - tableview dataSource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self judgeRowType] == noGropRowType) return 1; //不分组类型
    else if([self judgeRowType] == gropRowType) return self.dataSource.count; //分组类型
    return 0; //数据源没有数据
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self judgeRowType] == noGropRowType) return self.dataSource.count; //不分组类型
    else if([self judgeRowType] == gropRowType) return ((NSArray *)self.dataSource[section]).count; //分组类型
    return 0; //数据源没有数据
}

#pragma mark 设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - headHeight & footerHeight

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain) return 0;
    if (section == 0) {
        return 10.0f;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (![tableView.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) return 0;
    if (tableView.style == UITableViewStylePlain) return 0;
    if (section == ([tableView.dataSource numberOfSectionsInTableView:tableView] - 1)) {
        return 10.f;
    }
    return 5.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }
    return cell;
}

#pragma mark - 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 解析每行DataSource

/** 获取 dataSource rowType */
-(NSUInteger)getRowType:(NSArray *)dataSource indexPath:(NSIndexPath *)indexPath{
    if([self judgeRowType] == noGropRowType) return [self noGroupRowTypeFromArray:dataSource indexPath:indexPath];
    else if([self judgeRowType] == gropRowType) return [self rowTypeFromArray:dataSource indexPath:indexPath];
    return 0; //数据源没有数据
}

//解析tableView 每组的 枚举类型
- (NSUInteger)rowTypeFromArray:(NSArray *)dataSource indexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath && dataSource.count > 0 && dataSource[indexPath.section] && dataSource[indexPath.section][indexPath.row] && dataSource[indexPath.section][indexPath.row][DWRowType]);
    return [dataSource[indexPath.section][indexPath.row][DWRowType] integerValue];
}

//解析不是分组情况下
- (NSUInteger)noGroupRowTypeFromArray:(NSArray *)dataSource indexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath && dataSource.count > 0 && dataSource[indexPath.row] && dataSource[indexPath.row] && dataSource[indexPath.row][DWRowType]);
    return [dataSource[indexPath.row][DWRowType] integerValue];
}

#pragma mark - 判断是分组还是不分组 DataSource
-(DWBaseTableAdapterRowEnum)judgeRowType{
    if(self.dataSource.count > 0){
        if([[self.dataSource lastObject] isKindOfClass:[NSArray class]]){ //分组类型
            return gropRowType;
        }else{
            return noGropRowType;
        }
    }
    return dataSourceNormal;
}

@end
