//
//  TableViewEditRadioViewController.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/7/1.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "TableViewEditRadioViewController.h"
#import "PhotoModel.h"
#import <YYModel.h>
#import "TableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UI_SafeArea_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0.0)
#define UI_NavBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88.0:64.0)

@interface TableViewEditRadioViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TableViewEditRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"编辑";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 44);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TableViewCellID"];
}
- (void)editAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    } else if ([sender.titleLabel.text isEqualToString:@"完成"]) {
        [self.tableView setEditing:NO animated:NO];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PhotoModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
/**
 获取数据
 */
- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"textJson" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = [json objectForKey:@"data"];
    for (NSDictionary *dict in dataArray) {
        PhotoModel *model = [PhotoModel yy_modelWithDictionary:dict];
        model.isSelected = @"normal";
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI_NavBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NavBar_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
