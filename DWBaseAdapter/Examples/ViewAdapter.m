//
//  ViewAdapter.m
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/25.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "ViewAdapter.h"
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

@interface ViewAdapter() <ViewAdapterTypeCell4Delegate>

@end

@implementation ViewAdapter


-(NSMutableArray *)instanceDataSource{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    DWBaseTableDataSourceModel *cellModel_1 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell1 data:@(100) cell:[ViewAdapterTypeCell1 class]];
    [dataArray addObject:cellModel_1];
    
    
    DWBaseTableDataSourceModel *cellModel_2 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell2 data:nil cell:[ViewAdapterTypeCell2 class]];
    [dataArray addObject:cellModel_2];
    
    
    DWBaseTableDataSourceModel *cellModel_3 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell3 data:@{@"text":@"这是个传入参数, 并且cell高度也是传入model指定的", @"height":@(80)} cell:[ViewAdapterTypeCell3 class]];
    [dataArray addObject:cellModel_3];
    
    
    DWBaseTableDataSourceModel *cellModel_4 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell4 data:@{@"text":@"这是个传入cell自定义代理"} cell:[ViewAdapterTypeCell4 class] delegate:self];
    [dataArray addObject:cellModel_4];
    
    
    DWBaseTableDataSourceModel *cellModel_5 = [DWBaseTableDataSourceModel initWithTag:ViewAdapterType_cell4 data:nil cell:[ViewAdapterTypeCell5 class]];
    [dataArray addObject:cellModel_5];
    
    return dataArray;
}


#pragma mark - custom delegate

-(void)cell4_clickDelegate{
    NSLog(@"点击了 cell4");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self deleteCellWithIndexPath:indexPath indexSet:nil];
}


@end
