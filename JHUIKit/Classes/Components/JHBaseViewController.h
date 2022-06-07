//
//  JHBaseViewController.h
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import <UIKit/UIKit.h>
@class JHListViewFlowLayout;
@class JHBaseViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseViewController : UIViewController
@property(nonatomic,strong) UICollectionView *listView;
@property(nonatomic,strong) JHListViewFlowLayout *layout;
@property(nonatomic,strong) __kindof JHBaseViewModel *viewModel;

-(void)registerReusable;

-(void)invalidateLayout;

-(void)reloadData;

-(void)requestData;

-(void)viewDidTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
@end

NS_ASSUME_NONNULL_END
