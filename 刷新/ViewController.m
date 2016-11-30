//
//  ViewController.m
//  刷新
//
//  Created by zhangqian on 16/11/30.
//  Copyright © 2016年 Development. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>
#import "MJDIYHeader.h"
//获取屏幕宽高
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    __weak __typeof(self) weakSelf = self;
    self.tableview.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];

    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellNst = @"cellRegister";
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNst];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNst];
       
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"测试-%ld",indexPath.row] ;
    return cell;
    

}

#pragma mark -    处理刷新数据
- (void)loadNewData {
    __weak __typeof(self) weakSelf = self;
    
    [weakSelf.tableview.mj_header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
