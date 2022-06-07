//
//  UICollectionViewCell+JHAddition.h
//  JHUIKit
//
//  Created by junqhao on 2022/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (JHAddition)

//不准,已废弃
- (NSIndexPath *)getIndexPath;

- (UICollectionView *)getCollectionView;

@end

NS_ASSUME_NONNULL_END
