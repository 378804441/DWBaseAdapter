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
    gropRowType,       //分组
    dataSourceNormal   //数据源为空
};


@interface DWBaseTableAdapter()

/** 绑定到该适配器上的handler */
@property (nonatomic, assign) id adapterHandler;

@end

@implementation DWBaseTableAdapter

- (instancetype)init{
    self = [super init];
    if (self) {
        self.defaultCellHeight = 44;
    }
    return self;
}


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


#pragma mark - headHeight & footerHeight

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (![tableView.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) return 0;
    if (tableView.style == UITableViewStylePlain) return 0;
    if (section == ([tableView.dataSource numberOfSectionsInTableView:tableView] - 1)) return CGFLOAT_MIN;
    return CGFLOAT_MIN;
}


#pragma mark - 常规 tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cellObjc = [self getDataSourceWithSourceArray:self.dataSource indexPath:indexPath type:DWBaseTableAdapterRowType_rowCell];
    // 如果没有遵循 DWBaseCellProtocol 协议将直接返回高度
    if (![cellObjc conformsToProtocol:@protocol(DWBaseCellProtocol)]) {
        return self.defaultCellHeight;
    }
    
    id <DWBaseCellProtocol>protocolCell = cellObjc;
    /** 需要传Model 动态计算高度 */
    if([protocolCell respondsToSelector:@selector(getAutoCellHeightWithModel:)]){
        id cellData = [self getDataSourceWithSourceArray:self.dataSource indexPath:indexPath type:DWBaseTableAdapterRowType_rowData];
        return [protocolCell getAutoCellHeightWithModel:cellData];
    /** 不需要传参 固定高度 */
    }else if([protocolCell respondsToSelector:@selector(getAutoCellHeight)]){
        return [protocolCell getAutoCellHeight];
    /** 安全高度 */
    }else return self.defaultCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell 类对象
    id cellObjc = [self getDataSourceWithSourceArray:self.dataSource indexPath:indexPath type:DWBaseTableAdapterRowType_rowCell];
    // 如果没有遵循 DWBaseCellProtocol 协议将直接返回安全数组
    if (![cellObjc conformsToProtocol:@protocol(DWBaseCellProtocol)]) {
        return [self createSecurityCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    id <DWBaseCellProtocol>protocolCell = cellObjc;
    
    NSString *errorStr = [NSString stringWithFormat:@"既然遵循了 DWBaseCellProtocol 协议, 就请实现协议里的初始化方法。不然直接重写 tableView cellForRowAtIndexPath 方法。\n Cell 名称 : %@", NSStringFromClass([protocolCell class])];
    NSAssert([protocolCell conformsToProtocol:@protocol(DWBaseCellProtocol)] &&
             [protocolCell respondsToSelector:@selector(cellWithTableView:)],
             errorStr);
    
    // 初始化Cell 实例对象
    id cell = [protocolCell cellWithTableView:tableView];
    
    // 实例对象不存在直接返回一个安全Cell
    if (!cell) return [self createSecurityCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    // 绑定数据
    id cellData = [self getDataSourceWithSourceArray:self.dataSource indexPath:indexPath type:DWBaseTableAdapterRowType_rowData];
    if ([cell respondsToSelector:@selector(bindWithCellModel:indexPath:)]) {
        [cell bindWithCellModel:cellData indexPath:indexPath];
    }
    
    /** 指定delegate */
    id delegateObj = [self getDataSourceWithSourceArray:self.dataSource indexPath:indexPath type:DWBaseTableAdapterRowType_rowDelegate];
    if (delegateObj) {
        [cell setMyDelegate:delegateObj];
    }
    return cell;
}

/** 创建安全Cell */
- (UITableViewCell *)createSecurityCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - all action

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.myDelegate respondsToSelector:@selector(didSelectTableView:indexPath:adapter:)]) {
        [self.myDelegate didSelectTableView:tableView indexPath:indexPath adapter:self];
    }
}


#pragma mark - 解析每行DataSource

-(id)getDataSourceWithSourceArray:(NSArray *)sourceArray indexPath:(NSIndexPath *)indexPath type:(DWBaseTableAdapterRowType)type{
    if([self judgeRowType] == noGropRowType) return [self noGroupRowTypeFromArray:sourceArray indexPath:indexPath type:type];
    else if([self judgeRowType] == gropRowType) return [self rowTypeFromArray:sourceArray indexPath:indexPath type:type];
    return nil; //数据源没有数据
}

//解析tableView 每组的 枚举类型
- (id)rowTypeFromArray:(NSArray *)sourceArray indexPath:(NSIndexPath *)indexPath type:(DWBaseTableAdapterRowType)type{
    NSParameterAssert(indexPath && sourceArray.count > 0 && sourceArray[indexPath.section] && sourceArray[indexPath.section][indexPath.row]);
    DWBaseTableDataSourceModel *dataSourceModel = sourceArray[indexPath.section][indexPath.row];
    return [self parsingDataSourceWithModel:dataSourceModel type:type];
}

//解析不是分组情况下
- (id)noGroupRowTypeFromArray:(NSArray *)sourceArray indexPath:(NSIndexPath *)indexPath type:(DWBaseTableAdapterRowType)type{
    NSParameterAssert(indexPath && sourceArray.count > 0 && sourceArray[indexPath.row] && sourceArray[indexPath.row]);
    DWBaseTableDataSourceModel *dataSourceModel = sourceArray[indexPath.row];
    return [self parsingDataSourceWithModel:dataSourceModel type:type];
}

- (id)parsingDataSourceWithModel:(DWBaseTableDataSourceModel *)dataSourceModel type:(DWBaseTableAdapterRowType)type{
    switch (type) {
        case DWBaseTableAdapterRowType_rowType:
            return @(dataSourceModel.tag);
            break;
        case DWBaseTableAdapterRowType_rowData:
            return dataSourceModel.data;
            break;
        case DWBaseTableAdapterRowType_rowCell:
            return dataSourceModel.cell;
            break;
        case DWBaseTableAdapterRowType_rowDelegate:
            return dataSourceModel.myDelegate;
            break;
        default:
            return nil;
            break;
    }
}
/****************** 获取 rowType END *******************/


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

/** 绑定handler */
-(void)configHandler:(id)handler{
    if (handler) {
        self.adapterHandler = handler;
    }
}


@end
