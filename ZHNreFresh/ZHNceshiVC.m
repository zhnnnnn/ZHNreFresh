//
//  ZHNceshiVC.m
//  ZHNreFresh
//
//  Created by zhn on 16/5/12.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNceshiVC.h"
#import "UIScrollView+ZHNfresh.h"
#import "zhnFreshHeadrView.h"

@interface ZHNceshiVC()

@property (nonatomic,strong) zhnFreshHeadrView * headerView;
@end



@implementation ZHNceshiVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.headerView = [zhnFreshHeadrView freshHeadrWithFrshAction:^{
        NSLog(@"aada");
    }];
  
    self.tableView.zhnFreshView = self.headerView;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"😄哈哈哈";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.headerView endFreshing];
}




@end
