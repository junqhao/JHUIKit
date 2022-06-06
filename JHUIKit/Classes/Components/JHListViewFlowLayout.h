//
//  JHListViewFlowLayout.h
//  JHUIKit
//
//  Created by junqhao on 2022/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHListViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional
///item size, invalid when estimatedSize isn't empty
- (CGSize)jh_listView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath;
/// 列数 至少为1
- (NSInteger)jh_listView:(UICollectionView *)collectionView columnsAtSection:(NSInteger)section;
/// 每行的距离
- (CGFloat)jh_listView:(UICollectionView *)collectionView lineSpacingAtSection:(NSInteger)section;
/// 每列的距离
- (CGFloat)jh_listView:(UICollectionView *)collectionView itemSpacingAtSection:(NSInteger)section;
/// /// section的内间距
- (UIEdgeInsets)jh_listView:(UICollectionView *)collectionView insetsAtSection:(NSInteger)section;
/// header size
- (CGSize)jh_listView:(UICollectionView *)collectionView headerSizeAtSection:(NSInteger)section;
/// footer size
- (CGSize)jh_listView:(UICollectionView *)collectionView footerSizeAtSection:(NSInteger)section;
/// pin to top
- (BOOL)jh_listView:(UICollectionView *)collectionView headerPinToTopAtSection:(NSInteger)section;
///decorationView class for section
- (NSString *)jh_listView:(UICollectionView *)collectionView decorationViewClassAtSection:(NSInteger)section;
@end

@interface JHListViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<JHListViewDelegateFlowLayout> delegate;
@end

NS_ASSUME_NONNULL_END
