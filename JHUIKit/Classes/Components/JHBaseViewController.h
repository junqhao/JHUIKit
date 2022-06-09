//
//  JHBaseViewController.h
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import <UIKit/UIKit.h>
#import "JHBaseListView.h"
#import "JHListViewFlowLayout.h"
#import "JHBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseViewController : UIViewController
@property(nonatomic,strong) __kindof JHBaseListView *listView;
@property(nonatomic,strong) __kindof JHListViewFlowLayout *layout;
@property(nonatomic,strong) __kindof JHBaseViewModel *viewModel;

-(void)registerReusable;

-(void)invalidateLayout;

-(void)reloadData;

-(void)requestData;

-(void)viewDidTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
@end

NS_ASSUME_NONNULL_END
