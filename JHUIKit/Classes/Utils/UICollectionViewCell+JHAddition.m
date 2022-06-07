//
//  UICollectionViewCell+JHAddition.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/31.
//
#import "UICollectionViewCell+JHAddition.h"

@implementation UICollectionViewCell (JHAddition)

- (NSIndexPath *)getIndexPath {
    return [[self getCollectionView] indexPathForItemAtPoint:self.center];
}

- (UICollectionView *)getCollectionView {
    UIView *superView = self.superview;
    while (superView && ![superView isKindOfClass:[UICollectionView class]]) {
        superView = superView.superview;
    }
    if (superView) {
        return (UICollectionView *)superView;
    }
    return nil;
}
@end
