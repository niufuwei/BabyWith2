//
//  DeviceListCell.m
//  BabyWith
//
//  Created by shanchen on 14-8-11.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _accLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 70, 40)];
        _accLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_accLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
