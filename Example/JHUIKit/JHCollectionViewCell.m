//
//  MasonryCollectionViewCell.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import "JHCollectionViewCell.h"

@implementation JHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        [self addSubview:_label];
        
        //self.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0  blue:arc4random()%256 / 255.0  alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(20, 0, CGRectGetWidth( self.bounds), CGRectGetHeight( self.bounds));
}

@end
