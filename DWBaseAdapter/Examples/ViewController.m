//
//  ViewController.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "ViewController.h"
#import "ViewAdapter.h"

#define DWSCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<DWBaseTableViewProtocol>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ViewAdapter *adapter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    [self createAllAD];
    [self specifiedLinkEmailAD];
}


#pragma mark - 初始化UI

-(void)_initUI{
    [self.view addSubview:self.tableView];
}


#pragma mark - private method

/** 初始化AD */
-(void)createAllAD{
    _adapter = [[ViewAdapter alloc] init];
    _adapter.tableProtocolDelegate = self;
    _adapter.tableView             = self.tableView;
    _adapter.securityCellHeight    = CGFLOAT_MIN;
}

/** 指定AD */
-(void)specifiedLinkEmailAD{
    self.tableView.dataSource = _adapter;
    self.tableView.delegate   = _adapter;
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
