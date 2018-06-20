//
//  CollectionViewCell.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/20.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "CollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellWithModel:(PhotoModel *)model {
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:model.galary_item_path]];
    self.isSelectImageView.image = [UIImage imageNamed:model.isSelected];
}

@end
