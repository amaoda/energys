//
//  RootPageTableViewCell.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/23.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "RootPageTableViewCell.h"

@interface  RootPageTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation RootPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(RootPageModel *)model
{
    _titleLabel.text = model.name;
    _contentLabel.text = model.address;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
}




@end
