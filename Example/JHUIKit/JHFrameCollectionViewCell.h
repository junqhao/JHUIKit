//
//  JHFrameCollectionViewCell.h
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/6.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFood.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHFrameCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * imageView;
//@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) JHFood *food;
-(void)setData:(JHFood *)food;

+(CGFloat)getHeight:(JHFood *)food maxW:(CGFloat)maxW;
@end

NS_ASSUME_NONNULL_END
