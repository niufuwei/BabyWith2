//
//  FooterView.m
//  BabyWith
//
//  Created by shanchen on 14-8-8.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 1)];
        _line.backgroundColor = [UIColor grayColor];
        _line.alpha=0.3;
        [self addSubview:_line];
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
