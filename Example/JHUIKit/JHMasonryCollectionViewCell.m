//
//  MasonryCollectionViewCell.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import "JHMasonryCollectionViewCell.h"
#import "UICollectionViewCell+JHAddition.h"

@interface JHMasonryCollectionViewCell ()
@property (nonatomic,strong) JHMoreOptionView *opView;
@end

@implementation JHMasonryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.imageView];
        //self.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0  blue:arc4random()%256 / 255.0  alpha:1];
        self.backgroundColor = UIColor.lightGrayColor;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _label.preferredMaxLayoutWidth = self.frame.size.width-10-5-20;
    [_label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

-(void)setData:(JHFood *)food{
    self.opView.hidden = YES;
    self.food = food;
    self.label.text = food.name;
    
    UIImage *image = [UIImage imageNamed:food.photo];
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.right.lessThanOrEqualTo(self.button.mas_left).offset(-5);
    }];
    
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label);
        make.right.equalTo(self.contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.label);
        make.size.mas_equalTo([self getShowImageSize:image]);
    }];
    
}

-(CGSize)getShowImageSize:(UIImage *)image{
    CGSize size;
    CGFloat radio = image.size.width / image.size.height;
    CGFloat maxW = self.frame.size.width - 20;
    CGFloat realW = image.size.width;
    CGFloat realH = image.size.height;
    if (maxW >= realW) {
        size.width = realW;
        size.height = realH;
    }else{
        size.width = maxW;
        size.height = maxW / radio;
    }
    CGSize ceilSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ceilSize;
}

-(void)buttonClicked{
    if(self.button.isSelected){
        self.button.selected  = NO;
        self.opView.hidden = YES;
    }else{
        self.button.selected = YES;
        self.opView.hidden = NO;
        [self.opView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.size.mas_equalTo(self.opView.bounds.size);
        }];
    }
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        _label.backgroundColor = UIColor.whiteColor;
        _label.lineBreakMode = NSLineBreakByCharWrapping;
        _label.font = [UIFont systemFontOfSize:16];
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

-(UIButton *)button{
    if(!_button){
        _button = [[UIButton alloc] init];
        [_button setTitle:@"⋮" forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _button.backgroundColor = UIColor.whiteColor;
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(JHMoreOptionView *)opView{
    if(!_opView){
        _opView = [[JHMoreOptionView alloc] init];
        [self.contentView addSubview:_opView];
    }
    return _opView;
}

-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height= ceil(size.height);
    layoutAttributes.frame= cellFrame;
    return layoutAttributes;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"optSelected"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dic setObject:self.getIndexPath forKey:@"indexPath"];
        self.opView.hidden = YES;
        self.button.selected = NO;
        [self.nextResponder routerEventWithName:eventName userInfo:[dic copy]];
    }
}
@end
