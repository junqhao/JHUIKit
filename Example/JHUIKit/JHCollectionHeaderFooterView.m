//
//  JHCollectionHeaderFooterView.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import "JHCollectionHeaderFooterView.h"

@implementation JHCollectionHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        self.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0  blue:arc4random()%256 / 255.0  alpha:1];
       // self.backgroundColor = UIColor.orangeColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(15, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
