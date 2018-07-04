//
//  TableViewEditMultiSelectViewController.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/7/4.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "TableViewEditMultiSelectViewController.h"
#import "PhotoModel.h"
#import <YYModel.h>
#import "TableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UI_SafeArea_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0.0)
#define UI_NavBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88.0:64.0)

@interface TableViewEditMultiSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TableViewEditMultiSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"编辑";
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    UIBarButtonItem  *barBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(allSelectAction:)];
    self.navigationItem.rightBarButtonItems = @[barBtn,barBtn1];
    
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TableViewCellID"];
}
- (void)allSelectAction:(UIBarButtonItem *)sender {
    static BOOL flag = NO;
    flag = !flag;
    if (flag) {
        sender.title = @"全不选";
        for (int i = 0; i < self.dataSource.count; i++) {
            PhotoModel *itemModel = self.dataSource[i];
            itemModel.isSelected = @"select";
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        sender.title = @"全选";
        for (int i = 0; i < self.dataSource.count; i++) {
            PhotoModel *itemModel = self.dataSource[i];
            itemModel.isSelected = @"normal";
        }
        [self.tableView selectRowAtIndexPath:0 animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
- (void)editAction:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"删除";
    } else if ([sender.title isEqualToString:@"删除"]) {
        for (int i = 0; i < self.dataSource.count; i++) {
            PhotoModel *itemModel = self.dataSource[i];
            if ([itemModel.isSelected isEqualToString:@"select"]) {
                [self.dataSource removeObject:itemModel];
                // 当有元素被删除的时候i的值回退1 从而抵消因删除元素而导致的元素下标位移的变化
                i--;
            }
        }
        [self.tableView setEditing:NO animated:NO];
        sender.title = @"编辑";
        [self.tableView reloadData];
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
    // 不要设置这句话 不然没有效果
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PhotoModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        PhotoModel *itemModel = self.dataSource[indexPath.row];
        itemModel.isSelected = [itemModel.isSelected isEqual:@"normal"] ? @"select" : @"normal";
    } else {
        NSLog(@"不是编辑模式");
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        PhotoModel *itemModel = self.dataSource[indexPath.row];
        itemModel.isSelected = [itemModel.isSelected isEqual:@"normal"] ? @"select" : @"normal";
    } else {
        NSLog(@"不是编辑模式!");
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
        _tableView.allowsMultipleSelectionDuringEditing = YES;
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
