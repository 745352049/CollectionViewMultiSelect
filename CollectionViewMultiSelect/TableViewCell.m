//
//  TableViewCell.m
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/30.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellWithModel:(PhotoModel *)model {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.galary_item_path]];
    UIImage *image = [UIImage imageWithData:data];
    self.itemImageView.image = image;
    self.itemLabel.text = model.galary_item_path;
    self.isSelectImageView.image = [UIImage imageNamed:model.isSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
