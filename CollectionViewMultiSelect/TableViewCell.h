//
//  TableViewCell.h
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/30.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectImageView;
- (void)setCellWithModel:(PhotoModel *)model;

@end
