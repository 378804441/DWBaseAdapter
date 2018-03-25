//
//  ViewController.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "ViewController.h"
#import "UserAdapter.h"
#import "NewUserAdapter.h"

@interface ViewController ()<DWBaseTableViewProtocol>

@property (nonatomic, strong) UserAdapter *adapter;
@property (nonatomic, strong) NewUserAdapter *nAdapter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adapter = [[UserAdapter alloc] init];
    _adapter.myDelegate = self;
    
    _nAdapter = [[NewUserAdapter alloc] init];
    _nAdapter.myDelegate = self;
    
    [self createTableViewAdapter];
}

//初始化 tabViewAdapter
-(void)createTableViewAdapter{
    self.tableView.delegate = _adapter;
    self.tableView.dataSource = _adapter;
    [self.tableView reloadData];
}

//初始化 newTabViewAdapter
-(void)createNewTableViewAdapter{
    self.tableView.delegate = _nAdapter;
    self.tableView.dataSource = _nAdapter;
    [self.tableView reloadData];
}


#pragma mark - AdapterDelegate 点击切换 tableView 样式

-(void)didSelectTableView:(UITableView *)tabView indexPath:(NSIndexPath *)indexPath adapter:(id)adapter{
    if ([adapter isKindOfClass:[UserAdapter class]]) {
        [self createNewTableViewAdapter];
    }
    if ([adapter isKindOfClass:[NewUserAdapter class]]) {
        [self createTableViewAdapter];
    }
}



@end
