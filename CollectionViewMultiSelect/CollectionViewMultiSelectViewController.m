//
//  CollectionViewMultiSelectViewController.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/20.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "CollectionViewMultiSelectViewController.h"
#import "CollectionViewCell.h"
#import "YYModel.h"
#import "PhotoModel.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UI_SafeArea_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0.0)
#define UI_NavBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88.0:64.0)

@interface CollectionViewMultiSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *allSelectBtn;
@property (nonatomic, assign) int selectNum;
@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CollectionViewMultiSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isAllSelect = NO;
    self.selectNum = 0;
    [self loadData];
    [self createUI];
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
/**
 加载UI
 */
- (void)createUI {
    CGFloat buttomH = 44.0f + UI_SafeArea_Height;
    CGFloat btnW = SCREEN_WIDTH/3.0f;
    CGFloat btnH = 44.0f;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-32)/3, (SCREEN_WIDTH-32)/3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI_NavBar_Height, SCREEN_WIDTH,SCREEN_HEIGHT-buttomH-UI_NavBar_Height) collectionViewLayout:layout];
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
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-buttomH, SCREEN_WIDTH, buttomH)];
    buttomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:buttomView];
    
    self.selectLabel.frame = CGRectMake(0, 0, btnW, btnH);
    [buttomView addSubview:self.selectLabel];
    self.deleteBtn.frame = CGRectMake(btnW, 0, btnW, btnH);
    [buttomView addSubview:self.deleteBtn];
    self.allSelectBtn.frame = CGRectMake(btnW*2, 0, btnW, btnH);
    [buttomView addSubview:self.allSelectBtn];
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
    PhotoModel *itemModel = self.dataSource[indexPath.row];
    itemModel.isSelected = [itemModel.isSelected isEqual:@"normal"] ? @"select" : @"normal";
    if ([itemModel.isSelected isEqualToString: @"select"]) {
        self.selectNum = self.selectNum + 1;
    } else {
        self.selectNum = self.selectNum - 1;
    }
    if (self.selectNum == self.dataSource.count) {
        self.isAllSelect = YES;
        [self.allSelectBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    } else {
        self.isAllSelect = NO;
        [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    self.selectLabel.text =  [NSString stringWithFormat:@"已选%d张",self.selectNum];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}
- (void)allSelectAction {
    for (int i = 0; i < self.dataSource.count; i++) {
        PhotoModel *itemModel = self.dataSource[i];
        itemModel.isSelected = self.isAllSelect ? @"normal" : @"select";
    }
    self.isAllSelect = !self.isAllSelect;
    self.selectNum = self.isAllSelect ? (unsigned)self.dataSource.count : 0;
    self.selectLabel.text =  [NSString stringWithFormat:@"已选%lu张",self.isAllSelect ? (unsigned long)self.dataSource.count : 0];
    [self.allSelectBtn setTitle:self.isAllSelect ? @"取消全选" : @"全选" forState:UIControlStateNormal];
    [_collectionView reloadData];
}
- (void)deleteAction {
    for (int i = 0; i < self.dataSource.count; i++) {
        PhotoModel *itemModel = self.dataSource[i];
        if ([itemModel.isSelected isEqualToString:@"select"]) {
            [self.dataSource removeObjectAtIndex:i];
        }
    }
    self.isAllSelect = NO;
    self.selectNum = self.isAllSelect ? (unsigned)self.dataSource.count : 0;
    self.selectLabel.text =  [NSString stringWithFormat:@"已选%lu张",self.isAllSelect ? (unsigned long)self.dataSource.count : 0];
    [self.allSelectBtn setTitle:self.isAllSelect ? @"取消全选" : @"全选" forState:UIControlStateNormal];
    [_collectionView reloadData];
}
#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc] init];
        _selectLabel.font = [UIFont systemFontOfSize:14];
        _selectLabel.textColor = [UIColor whiteColor];
        _selectLabel.text = @"已选0张";
        _selectLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _selectLabel;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _deleteBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIButton *)allSelectBtn {
    if (!_allSelectBtn) {
        _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        _allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _allSelectBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_allSelectBtn addTarget:self action:@selector(allSelectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
