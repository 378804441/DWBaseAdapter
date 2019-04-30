//
//  ViewController.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "ViewController.h"
#import "ViewAdapter.h"            // 平铺类型
#import "ViewAdapterGroup.h"       // 分组类型

#define DWSCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<DWBaseTableViewProtocol>

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) ViewAdapter      *adapter;
@property (nonatomic, strong) ViewAdapterGroup *groupAdapter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    [self createAllAD];
    [self specifiedFlatAD];
}


#pragma mark - 初始化UI

-(void)_initUI{
    [self.view addSubview:self.tableView];
}


#pragma mark - private method

/** 初始化AD */
-(void)createAllAD{
    _adapter = [[ViewAdapter alloc] initAdapterWithTableView:self.tableView];
    _adapter.tableProtocolDelegate = self;
    _adapter.securityCellHeight    = CGFLOAT_MIN;
//    _adapter.closeHighlyCache      = YES;
    
    _groupAdapter = [[ViewAdapterGroup alloc] initAdapterWithTableView:self.tableView];
    _groupAdapter.tableProtocolDelegate = self;
}

/** 指定平铺AD */
-(void)specifiedFlatAD{
    self.tableView.dataSource = _adapter;
    self.tableView.delegate   = _adapter;
}

/** 指定分组AD */
-(void)specifiedGroupAD{
    self.tableView.dataSource = _groupAdapter;
    self.tableView.delegate   = _groupAdapter;
}

-(UITableView *)instanceTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DWSCREENWIDTH, self.view.frame.size.height -  64) style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    return tableView;
}


#pragma mark - 懒加载

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [self instanceTableView];
    }
    return _tableView;
}


@end
