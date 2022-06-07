//
//  JHListViewFlowLayout.h
//  JHUIKit
//
//  Created by junqhao on 2022/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHListViewFlowLayout;
@protocol JHListViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional
///item size, invalid when estimatedSize isn't empty
- (CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath;
/// 列数 至少为1
- (NSInteger)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout columnsAtSection:(NSInteger)section;
/// 每行的距离
- (CGFloat)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout lineSpacingAtSection:(NSInteger)section;
/// 每列的距离
- (CGFloat)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout itemSpacingAtSection:(NSInteger)section;
/// /// section的内间距
- (UIEdgeInsets)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout insetsAtSection:(NSInteger)section;
/// header size
- (CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout headerSizeAtSection:(NSInteger)section;
/// footer size
- (CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout footerSizeAtSection:(NSInteger)section;
/// pin to top
- (BOOL)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout headerPinToTopAtSection:(NSInteger)section;
///decorationView class for section
- (NSString *)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout decorationViewClassAtSection:(NSInteger)section;
@end

@interface JHListViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<JHListViewDelegateFlowLayout> delegate;

-(void)setCellSize:(CGSize)size atIndexPath:(NSIndexPath *)indexPath;

-(void)resetActualSizes;
@end

NS_ASSUME_NONNULL_END
