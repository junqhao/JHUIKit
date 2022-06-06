//
//  JHFrameCollectionViewCell.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/6.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHFrameCollectionViewCell.h"

@implementation JHFrameCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.imageView];
        //self.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0  blue:arc4random()%256 / 255.0  alpha:1];
        self.backgroundColor = UIColor.lightGrayColor;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //_label.preferredMaxLayoutWidth = self.frame.size.width-20;
    //[_label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
   // [self setData:_food];
}

-(void)setData:(JHFood *)food{
    self.food = food;
    self.label.text = food.name;
    
    UIImage *image = [UIImage imageNamed:food.photo];
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGSize labelSize = [self.class getLabelSize:food.name maxW:self.frame.size.width -20];
    
    //CGSize labelSize2 = [self.label sizeThatFits:CGSizeMake(self.frame.size.width -20, MAXFLOAT)];
    
    self.label.frame = CGRectMake(10, 10, labelSize.width,labelSize.height);
    
    CGSize imgSize = [self.class getImageSize:image maxW:self.frame.size.width -20];
    
    self.imageView.frame = CGRectMake(10, CGRectGetMaxY(self.label.frame) + 10,imgSize.width,imgSize.height);
    
    
}

+(CGFloat)getHeight:(JHFood *)food maxW:(CGFloat)maxW{
    UIImage *image = [UIImage imageNamed:food.photo];
    CGSize imgSize = [self getImageSize:image maxW:maxW];
    CGSize labelSize = [self getLabelSize:food.name maxW:maxW];
    CGFloat r = 10 + labelSize.height + 10 + imgSize.height + 10;
    return r;
}

+(CGSize)getLabelSize:(NSString *)text maxW:(CGFloat)maxW{
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size;
    CGSize ceilSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ceilSize;
}

+(CGSize)getImageSize:(UIImage *)image maxW:(CGFloat)maxW{
    CGSize size;
    CGFloat radio = image.size.width / image.size.height;
    CGFloat W = maxW;
    CGFloat realW = image.size.width;
    CGFloat realH = image.size.height;
    if (W >= realW) {
        size.width = realW;
        size.height = realH;
    }else{
        size.width = W;
        size.height = W / radio;
    }
    CGSize ceilSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ceilSize;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:16];
        _label.backgroundColor = UIColor.whiteColor;
        _label.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _label;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}


@end
