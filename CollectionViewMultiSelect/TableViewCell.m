//
//  TableViewCell.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/30.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "TableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellWithModel:(PhotoModel *)model {
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:model.galary_item_path]];
    self.itemLabel.text = model.galary_item_path;
    self.isSelectImageView.image = [UIImage imageNamed:model.isSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
