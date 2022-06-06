//
//  JHCollectionDecorationView.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import "JHCollectionDecorationView.h"

@implementation JHDecorationView_Type1

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tagView.backgroundColor = UIColor.greenColor;
       // self.backgroundColor = UIColor.purpleColor;
        
    }
    return self;
}
@end

@implementation JHDecorationView_Type2
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tagView.backgroundColor = UIColor.blueColor;
        //self.backgroundColor = UIColor.redColor;
    }
    return self;
}
@end


@implementation JHCollectionDecorationView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tagView = [UIView new];
        [self addSubview:self.tagView];
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    [self.tagView removeFromSuperview];
    [self addSubview:self.tagView];
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}
@end
