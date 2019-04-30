//
//  ViewAdapter_group.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/4/27.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapterGroup.h"
#import "DWBaseTableAdapter+Action.h"
#import "ViewAdapterTypeCell1.h"
#import "ViewAdapterTypeCell2.h"
#import "ViewAdapterTypeCell3.h"
#import "ViewAdapterTypeCell4.h"
#import "ViewAdapterTypeCell5.h"

typedef NS_ENUM(NSInteger, ViewAdapterType){
    ViewAdapterType_cell1 = 0,
    ViewAdapterType_cell2,
    ViewAdapterType_cell3,
    ViewAdapterType_cell4,
    ViewAdapterType_cell5,
};

@interface ViewAdapterGroup()<ViewAdapterTypeCell4Delegate>

@end

@implementation ViewAdapterGroup


#pragma mark - 数据初始化

-(NSMutableArray *)instanceDataSource{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    // 组 - 1
    DWBaseTableDataSourceModel *cellModel_1 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell1 data:@(100) cell:[ViewAdapterTypeCell1 class]];
    DWBaseTableDataSourceModel *cellModel_2 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell2 data:nil cell:[ViewAdapterTypeCell2 class]];
    DWBaseTableDataSourceModel *cellModel_3 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell3 data:@{@"text":@"这是个传入参数, 并且cell高度也是传入model指定的", @"height":@(80)} cell:[ViewAdapterTypeCell3 class]];
    NSArray *array_1 = @[cellModel_1, cellModel_2, cellModel_3];
    [dataArray addObject:array_1];
    
    // 组 - 2
    
    DWBaseTableDataSourceModel *cellModel_4 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell4 data:@{@"text":@"这是个传入cell自定义代理"} cell:[ViewAdapterTypeCell4 class] delegate:self];
    NSArray *array_2 = @[cellModel_4];
    [dataArray addObject:array_2];
    
    // 组 - 3
    DWBaseTableDataSourceModel *cellModel_5 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell4 data:nil cell:[ViewAdapterTypeCell5 class]];
    NSArray *array_3 = @[cellModel_5];
    [dataArray addObject:array_3];
    
    return dataArray;
}


#pragma mark - tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    sectionLabel.text = [NSString stringWithFormat:@"第%ld组", section];
    return sectionLabel;
}


#pragma mark - cell delegate

-(void)cell4_clickDelegate{
    NSLog(@"点击了 cell4");
    NSMutableArray *dataSourceM = [NSMutableArray arrayWithArray:self.dataSource];
    
    NSMutableArray *section_1 = [NSMutableArray arrayWithArray:dataSourceM[0]];
    [section_1 removeLastObject];
    [section_1 removeLastObject];
    [section_1 removeLastObject];
    
    [dataSourceM replaceObjectAtIndex:0 withObject:section_1];
    self.diffDataSource = [dataSourceM copy];
    [self reloadAdapter];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
//    [self deleteCellWithIndexPath:indexPath indexSet:indexSet];
}


@end
