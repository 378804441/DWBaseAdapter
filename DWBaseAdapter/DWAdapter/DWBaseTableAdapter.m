//
//  DWBaseTableAdapter.m
//  BaseTableView 适配器
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "DWBaseTableAdapter.h"

#define WS(weakSelf)    __weak   __typeof(&*self) weakSelf = self;
#define SS(strongSelf)  __strong __typeof__(weakSelf) strongSelf = weakSelf;

#define IsEmpty(str)    (str == nil || ![str respondsToSelector:@selector(isEqualToString:)] || [str isEqualToString:@""])

typedef NS_ENUM(NSInteger, DWBaseTableAdapterRowEnum){
    DWBaseTableAdapterRow_noGrop = 0, //不分组
    DWBaseTableAdapterRow_grop,       //分组
    DWBaseTableAdapterRow_normal      //数据源为空
};

@interface DWBaseTableAdapter()

/** 绑定到该适配器上的handler */
@property (nonatomic, assign) id adapterHandler;

/** 最大线程 */
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation DWBaseTableAdapter

- (instancetype)init{
    self = [super init];
    if (self) {
        self.securityCellHeight = 44;
        _semaphore = dispatch_semaphore_create(1);
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


#pragma mark - private method

/** 删除cell */
-(void)deleteCellWithIndexPath:(NSIndexPath * __nullable)indexPath indexSet:(NSIndexSet * __nullable)indexSet{
    
    /**
     如果是不分组类型 就算传了indexSet 也会置为空
     如果indexSet 不为空 (分组类型 并且 要删除整个session) 将会给indexPath一个默认值 为了通过断言检测
     */
    DWBaseTableAdapterRowEnum rowType = [self checkRowType];
    if (rowType == DWBaseTableAdapterRow_noGrop) indexSet = nil;
    if (indexSet) indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    WS(weakSelf);
    [self checkDataSourceWithIndexPath:indexPath block:^(DWBaseTableAdapterRowEnum type) {
        SS(strongSelf);
        if (type == DWBaseTableAdapterRow_noGrop) {
            dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            dispatch_semaphore_signal(strongSelf.semaphore);
        }else if(type == DWBaseTableAdapterRow_grop){
            
            // 删除整个session
            if (indexSet) {
                NSInteger deleteLocation = indexSet.firstIndex;
                dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
                [self.dataSource removeObjectAtIndex:deleteLocation];
                [self.tableView beginUpdates];
                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                dispatch_semaphore_signal(strongSelf.semaphore);
                return ;
            }
            
            // 删除session 里面的某一行
            dispatch_semaphore_wait(strongSelf.semaphore, DISPATCH_TIME_FOREVER);
            
            NSMutableArray * tempArr = [[NSMutableArray alloc] init];
            tempArr = [self.dataSource[indexPath.section] mutableCopy];
            [tempArr removeObjectAtIndex:indexPath.row];
            [self.dataSource replaceObjectAtIndex:indexPath.section withObject:tempArr];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            dispatch_semaphore_signal(strongSelf.semaphore);
        }
    }];
}

// 检查是否合法
-(void)checkDataSourceWithIndexPath:(NSIndexPath *)indexPath block:(void(^)(DWBaseTableAdapterRowEnum type))blcok{
    NSParameterAssert(self.tableView);
    NSParameterAssert([indexPath isKindOfClass:[NSIndexPath class]]);
    
    DWBaseTableAdapterRowEnum rowType = [self checkRowType];
    if (rowType == DWBaseTableAdapterRow_noGrop) {
        NSParameterAssert(indexPath && self.dataSource.count > 0 && self.dataSource[indexPath.row] && indexPath.section == 0);
        if (blcok) blcok(rowType);
    }else if(rowType == DWBaseTableAdapterRow_grop){
        NSParameterAssert(indexPath && self.dataSource.count > 0 && self.dataSource[indexPath.section] && self.dataSource[indexPath.section][indexPath.row]);
        if (blcok) blcok(rowType);
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
    id cellObjc = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowCell];
    // 如果没有遵循 DWBaseCellProtocol 协议将直接返回高度
    if (![cellObjc conformsToProtocol:@protocol(DWBaseCellProtocol)]) {
        return self.securityCellHeight;
    }
    
    id <DWBaseCellProtocol>protocolCell = cellObjc;
    /** 需要传Model 动态计算高度 */
    if([protocolCell respondsToSelector:@selector(getAutoCellHeightWithModel:)]){
        id cellData = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowData];
        return [protocolCell getAutoCellHeightWithModel:cellData];
    /** 不需要传参 固定高度 */
    }else if([protocolCell respondsToSelector:@selector(getAutoCellHeight)]){
        return [protocolCell getAutoCellHeight];
    /** 安全高度 */
    }else return self.securityCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell 类对象
    id cellObjc = [self getDataSourceWithIndexPath:indexPath type:DWBaseTableAdapterRowType_rowCell];
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
    if ([self.tableProtocolDelegate respondsToSelector:@selector(didSelectTableView:indexPath:adapter:)]) {
        [self.tableProtocolDelegate didSelectTableView:tableView indexPath:indexPath adapter:self];
    }
}


#pragma mark - 解析每行DataSource

-(id)getDataSourceWithIndexPath:(NSIndexPath *)indexPath type:(DWBaseTableAdapterRowType)type{
    if([self checkRowType] == DWBaseTableAdapterRow_noGrop) return [self noGroupRowTypeFromArray:self.dataSource indexPath:indexPath type:type];
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

/** 绑定handler */
-(void)configHandler:(id)handler{
    if (handler) {
        self.adapterHandler = handler;
    }
}


@end
