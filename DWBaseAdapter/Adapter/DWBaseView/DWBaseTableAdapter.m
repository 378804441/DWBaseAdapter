//
//  DWBaseTableAdapter.m
//  BaseTableView 适配器
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "DWBaseTableAdapter.h"
#import "DWBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, DWBaseTableAdapterRowEnum){
    noGropRowType = 0, //不分组
    gropRowType,        //分组
    dataSourceNormal //数据源为空
};

NSString *const DWRowType = @"DWRowType"; //储存tableView时候的key

@interface DWBaseTableAdapter()

@end

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

/** 重写 estimatedHeightForRowAtIndexPath 更改tabview生命周期
     从原本的
 1.先调用numberOfRowsInSection
 2.再调用heightForRowAtIndexPath
 3.再调用cellForRowAtIndexPath
 
 变成
 
 1.numberOfRowsInSection
 2.estimatedHeightForRowAtIndexPath
 3.cellForRowAtIndexPath
 4.heightForRowAtIndexPath
 
 以防止 在 heightForRowAtIndexPath 中调用 cellForRowAtIndexPath出现 EXC_BAD_ACCESS 错误
 
 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger type = [self getRowType:self.dataSource indexPath:indexPath];
    /** 查看cell缓存池时候有缓存 */
    NSDictionary *reusableTableCells = [tableView valueForKey:@"reusableTableCells"];
    if (reusableTableCells.allKeys.count > 0) {
        NSInteger cellRow = ((NSMutableDictionary *)[tableView valueForKeyPath:@"tentativeCells"]).allKeys.count;
        /**
             为甚么判断
             多个 Adapter 切换时候 有缓存垃圾cell缓存数据会出现数据紊乱
         */
        UITableViewCell *cell;
        NSDictionary *cacheCell = (NSMutableDictionary *)[tableView valueForKeyPath:@"tentativeCells"];
        for (int i=0; i<cellRow; i++) {
            if (type < cellRow) { //如果 缓存个数小于 rowType  直接用 type 进行赋值
                cell = [self judgeRowType] == noGropRowType ? cacheCell[[[cacheCell.allKeys reverseObjectEnumerator] allObjects][type]] :
                cacheCell[cacheCell.allKeys[type]];
            }else{ //如果 缓存cell 个数大于等于 rowType 就用cell缓存个数-1 个来进行赋值
                cell = cacheCell[[[cacheCell.allKeys reverseObjectEnumerator] allObjects][cellRow-1]];
                
            }
        }
        
        if([cell isKindOfClass:[DWBaseTableViewCell class]]){ //判断是否继承 DWBaseTableViewCell
            DWBaseTableViewCell *dwCell = (DWBaseTableViewCell *)cell;
            return [dwCell getAutoCellHeight];
        }
        return 44;
    }
    
    /** 正常布局 */
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[DWBaseTableViewCell class]]){ //判断是否继承 DWBaseTableViewCell
        DWBaseTableViewCell *dwCell = (DWBaseTableViewCell *)cell;
        return [dwCell getAutoCellHeight];
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }
    return cell;
}

#pragma mark - 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    if ([self.myDelegate respondsToSelector:@selector(didSelectTableView:indexPath:adapter:)]) {
        [self.myDelegate didSelectTableView:tableView indexPath:indexPath adapter:self];
    }
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
