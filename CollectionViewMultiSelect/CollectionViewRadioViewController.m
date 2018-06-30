//
//  CollectionViewRadioViewController.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/30.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "CollectionViewRadioViewController.h"
#import "CollectionViewCell.h"
#import "YYModel.h"
#import "PhotoModel.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UI_SafeArea_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0.0)
#define UI_NavBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88.0:64.0)

@interface CollectionViewRadioViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation CollectionViewRadioViewController

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
    [self collectionView];
}
- (void)deleteAction {
    if ([self.indexPath length] == 0) {
        NSLog(@"请选择要删除的图片");
        return;
    }
    PhotoModel *itemModel = [self.dataSource objectAtIndex:self.indexPath.row];
    [self.dataSource removeObject:itemModel];
    [self.collectionView deleteItemsAtIndexPaths:@[self.indexPath]];
    self.indexPath = NULL;
}
#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count) {
        return self.dataSource.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    PhotoModel *itemModel = self.dataSource[indexPath.row];
    [cell setCellWithModel:itemModel];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoModel *itemModel = [self.dataSource objectAtIndex:indexPath.row];
    itemModel.isSelected = [itemModel.isSelected isEqual:@"normal"] ? @"select" : @"normal";
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    // 取消之前选中的 indexPath
    if ([self.indexPath length] == 2) {
        PhotoModel *model = [self.dataSource objectAtIndex:self.indexPath.row];
        model.isSelected = [model.isSelected isEqual:@"normal"] ? @"select" : @"normal";
        [collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
    }
    // 记录当前选择的 indexPath
    self.indexPath = indexPath;
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
}
#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-32)/3, (SCREEN_WIDTH-32)/3);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI_NavBar_Height, SCREEN_WIDTH,SCREEN_HEIGHT-UI_NavBar_Height) collectionViewLayout:layout];
        [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCellID"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
