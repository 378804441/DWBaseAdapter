//
//  DWBaseTableAdapter.m
//  BaseTableView 适配器
//
//  Created by 丁巍 on 2018/12/11.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "DWBaseTableAdapter.h"
#import "GDiffCore.h"
#import "DWBaseTableAdapter+Action.h"


@interface DWBaseTableAdapter()

@property (nonatomic, strong) NSMutableDictionary *heightCache;     //高度缓存

@end

@implementation DWBaseTableAdapter


#pragma mark - init method

/** 初始化 adapter */
-(instancetype)initAdapterWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        NSParameterAssert(tableView);
        _tableView              = tableView;
        self.securityCellHeight = 44;
        self.semaphore          = dispatch_semaphore_create(1);
        self.heightCache        = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)updateAdapterTableView:(UITableView *)tableView{
    NSParameterAssert(tableView);
    _tableView = tableView;
}


#pragma mark - 初始化DataSource方法

//数据源初始化
-(NSArray *)dataSource{
    if(!_dataSource){
        _dataSource = [[self instanceDataSource] copy];
    }
    return _dataSource;
}

// 静态数据源初始化 重写该方法即可
-(NSMutableArray *)instanceDataSource{
    NSMutableArray *array = [NSMutableArray array];
    return array;
}


#pragma mark - public method

/** 刷新adapter (更改数据源将会进行 diff计算 并精准刷新) */
-(void)reloadAdapter{
    if (IsNull(self.diffDataSource)) {
        self.diffDataSource = self.dataSource;
    }
    
//    GDiffCore *diff = [GDiffCore new];
//    DWIndexManager *result = [diff diff:self.dataSource newArray:self.diffDataSource];
//    
//    [self deleteCellWithIndexPaths:result.deletes];
}

//清除高度缓存
-(void)clearCache{
    [self.heightCache removeAllObjects];
}


#pragma mark - getter & setter

// 缓存高度不让生效
-(void)setCloseHighlyCache:(BOOL)closeHighlyCache{
    if (closeHighlyCache) {
        self.heightCache = nil;
    }
}


#pragma mark - tableview dataSource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self checkRowType] == DWBaseTableAdapterRow_noGrop) return 1; //不分组类型
    else if([self checkRowType] == DWBaseTableAdapterRow_grop) return self.dataSource.count; //分组类型
    return 0; //数据源没有数据
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self checkRowType] == DWBaseTableAdapterRow_noGrop) return self.dataSource.count; //不分组类型
    else if([self checkRowType] == DWBaseTableAdapterRow_grop) return ((NSArray *)self.dataSource[section]).count; //分组类型
    return 0; //数据源没有数据
}


#pragma mark - headHeight & footerHeight

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self checkRowType] == DWBaseTableAdapterRow_grop){
        if (section == 0) return CGFLOAT_MIN;
        return 10;
    }
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
    id <DWBaseCellProtocol>cellObjc = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowCell];
    // 数据源添加进来的Cell如果没有遵循该协议直接返回安全高度
    if (![cellObjc conformsToProtocol:@protocol(DWBaseCellProtocol)]) return self.securityCellHeight==0 ? CGFLOAT_MIN : self.securityCellHeight;
    
    //高度缓存
    DWBaseTableDataSourceModel *dataModel = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowModel];
    NSString *heightKey = [NSString stringWithFormat:@"%lu", (unsigned long)dataModel.hash];
    NSNumber *heightNumber = heightKey ? self.heightCache[heightKey] : nil;
    if (heightNumber) {
        return [heightNumber floatValue];
    } else {
        CGFloat cellH;
        /** 需要传Model 动态计算高度 */
        if([cellObjc respondsToSelector:@selector(getAutoCellHeightWithModel:)]){
            id cellData = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowData];
            cellH = [cellObjc getAutoCellHeightWithModel:cellData];
            
        /** 不需要传参 固定高度 */
        }else if([cellObjc respondsToSelector:@selector(getAutoCellHeight)]){
            cellH = [cellObjc getAutoCellHeight];
            
        /** 安全高度 */
        }else{
            cellH = self.securityCellHeight==0 ? CGFLOAT_MIN : self.securityCellHeight;
        }
        
        if (heightKey) self.heightCache[heightKey] = @(cellH);
        return cellH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cellObjc = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowCell];
    
    // 如果没有遵循 DWBaseCellProtocol 协议将直接返回安全数组
    if (![cellObjc conformsToProtocol:@protocol(DWBaseCellProtocol)]) {
        return [self createSecurityTableView:tableView cellForRowAtIndexPath:indexPath cellName:nil];
    }
    
    id <DWBaseCellProtocol>protocolCell = cellObjc;
    
    NSString *errorStr = [NSString stringWithFormat:@"既然遵循了 DWBaseCellProtocol 协议, 就请实现协议里的初始化方法。不然直接重写 tableView cellForRowAtIndexPath 方法。\n Cell 名称 : %@", NSStringFromClass([protocolCell class])];
    NSAssert([protocolCell conformsToProtocol:@protocol(DWBaseCellProtocol)] &&
             [protocolCell respondsToSelector:@selector(cellWithTableView:)],
             errorStr);
    
    // 初始化Cell 实例对象
    id cell = [protocolCell cellWithTableView:tableView];
    
    // 实例对象不存在直接返回一个安全Cell
    if (!cell) return [self createSecurityTableView:tableView cellForRowAtIndexPath:indexPath cellName:NSStringFromClass(cell)];
    
    // 绑定数据
    id cellData = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowData];
    if ([cell respondsToSelector:@selector(bindWithCellModel:indexPath:)]) {
        [cell bindWithCellModel:cellData indexPath:indexPath];
    }
    
    /** 指定delegate */
    id delegateObj = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowDelegate];
    if (delegateObj) {
        [cell setMyDelegate:delegateObj];
    }
    return cell;
}

/** 创建安全Cell */
- (UITableViewCell *)createSecurityTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellName:(NSString *)cellName{
    UITableViewCell *cell;
    static NSString *CellIndentifier;
    static NSString *customCellIndentifier;
    if (IsEmpty(cellName)) {
        CellIndentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    }else{
        customCellIndentifier = cellName;
        cell = [tableView dequeueReusableCellWithIdentifier:customCellIndentifier];
    }
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - all action

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableProtocolDelegate respondsToSelector:@selector(didSelectTableView:indexPath:adapter:)]) {
        [self.tableProtocolDelegate didSelectTableView:tableView indexPath:indexPath adapter:self];
    }
}


#pragma mark - 解析每行DataSource

-(id)getDataSourceWithIndexPath:(NSIndexPath *)indexPath type:(DWBaseTableAdapterRowType)type{
    if([self checkRowType] == DWBaseTableAdapterRow_noGrop)    return [self noGroupRowTypeFromArray:self.dataSource indexPath:indexPath type:type];
    else if([self checkRowType] == DWBaseTableAdapterRow_grop) return [self rowTypeFromArray:self.dataSource indexPath:indexPath type:type];
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
    NSParameterAssert(indexPath && sourceArray.count > 0 && sourceArray[indexPath.row] && indexPath.section == 0);
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
        case DWBaseTableAdapterRowType_rowModel:
            return dataSourceModel;
            break;
        default:
            return nil;
            break;
    }
}
/****************** 获取 rowType END *******************/


#pragma mark - 判断是分组还是不分组 DataSource

-(DWBaseTableAdapterRowEnum)checkRowType{
    if(self.dataSource.count > 0){
        if([[self.dataSource lastObject] isKindOfClass:[NSArray class]] ||
           [[self.dataSource lastObject] isKindOfClass:[NSMutableArray class]]){ //分组类型
            return DWBaseTableAdapterRow_grop;
        }else{
            return DWBaseTableAdapterRow_noGrop;
        }
    }
    return DWBaseTableAdapterRow_normal;
}


@end
