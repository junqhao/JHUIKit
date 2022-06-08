//
//  MasonryCollectionViewCell.h
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import <UIKit/UIKit.h>
#import "JHFood.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMasonryCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) JHFood *food;
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)setData:(JHFood *)food;
@end

NS_ASSUME_NONNULL_END
