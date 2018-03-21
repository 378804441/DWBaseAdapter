//
//  DWBaseViewController.m
//  适配器模式
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "DWBaseViewController.h"

@interface DWBaseViewController ()


@end

@implementation DWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DWColor(244, 244, 244);
    [self.view addSubview:self.tableView];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [self instanceTableView];
        if (_refreshBOOL) {
            MYLog(@"注册了下拉刷新");
            //******下拉刷新
            //1.注册cell
            [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DWBaseTabView"];
            // 2.集成刷新控件
            [self setupRefresh];
            //***********************
        }
    }
    return _tableView;
}

- (void)setupRefresh{
    MYLog(@"重写setupRefresh方法。才能集成上下拉刷新 \n block方法来实现:\n\n - (void)setupRefresh{ \n __weak __typeof(self) weakSelf = self;\n self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{ \n MYLog(@\"刷新\");  // 结束刷新 \n [weakSelf.tableView.mj_header endRefreshing]; \n}];  \n //[self.myTableView.mj_header beginRefreshing]; //马上进入刷新状态 \n }");
}


-(UITableView *)instanceTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //tableView.showsVerticalScrollIndicator = NO; //去掉右边滚动条
    //tableView.scrollEnabled = NO; //禁止滑动
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //清除所有横线
    
    /** ios11 headView 与 footerView 不生效解决 */
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    /******************************************/
    
    return tableView;
}

@end
