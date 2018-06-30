//
//  TableViewRadioViewController.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/30.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "TableViewRadioViewController.h"
#import "PhotoModel.h"
#import <YYModel.h>
#import "TableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UI_SafeArea_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0.0)
#define UI_NavBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88.0:64.0)

@interface TableViewRadioViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation TableViewRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"单选";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 44);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TableViewCellID"];
}
- (void)deleteAction {
    if ([self.indexPath length] == 0) {
        NSLog(@"请选择要删除的图片");
        return;
    }
    PhotoModel *itemModel = [self.dataSource objectAtIndex:self.indexPath.row];
    [self.dataSource removeObject:itemModel];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    self.indexPath = NULL;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoModel *itemModel = self.dataSource[indexPath.row];
    itemModel.isSelected = [itemModel.isSelected isEqual:@"normal"] ? @"select" : @"normal";
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    // 取消之前选中的 indexPath
    if ([self.indexPath length] == 2) {
        PhotoModel *model = [self.dataSource objectAtIndex:self.indexPath.row];
        model.isSelected = [model.isSelected isEqual:@"normal"] ? @"select" : @"normal";
        [tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    // 记录当前选择的 indexPath
    self.indexPath = indexPath;
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
