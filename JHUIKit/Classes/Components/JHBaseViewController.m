//
//  JHBaseViewController.m
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import "JHBaseViewController.h"
#import "UIDevice+JHAddition.h"
#import "JHListViewFlowLayout.h"
#import "JHBaseViewModel.h"


@interface JHBaseViewController ()

@end

@implementation JHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = 0;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = [self title];
    self.viewModel = [[JHBaseViewModel alloc] init];
    self.layout = [[JHListViewFlowLayout alloc] init];
    self.layout.delegate = self.viewModel;
    self.listView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UIDevice.jh_aboveNavigationBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-UIDevice.jh_aboveNavigationBarHeight) collectionViewLayout:self.layout];
    [self.view addSubview:self.listView];
    self.listView.contentInset = UIEdgeInsetsMake(0, 0, UIDevice.jh_safeAreaInsets.bottom, 0);
    self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.listView.delegate = self.viewModel;
    self.listView.dataSource = self.viewModel;
    [self registerReusable];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)setLayout:(JHListViewFlowLayout *)layout{
    _layout = layout;
    self.listView.collectionViewLayout = _layout;
    if([_layout isKindOfClass:[JHListViewFlowLayout class]]){
        JHListViewFlowLayout *lay = (JHListViewFlowLayout *)_layout;
        lay.delegate = self.viewModel;
    }
    [self invalidateLayout];
}

-(void)setViewModel:(JHBaseViewModel *)viewModel{
    _viewModel = viewModel;
    self.listView.delegate = _viewModel;
    self.listView.dataSource = _viewModel;
    if([_layout isKindOfClass:[JHListViewFlowLayout class]]){
        JHListViewFlowLayout *lay = (JHListViewFlowLayout *)_layout;
        lay.delegate = _viewModel;
    }
}

-(void)requestData{
    [self.viewModel requestData];
}

-(void)registerReusable{
    [self.listView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
}

-(void)reloadData{
    [self.listView reloadData];
}

-(void)invalidateLayout{
    [_layout invalidateLayout];
}

-(NSString *)title{
    return @"";
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self viewDidTransitionToSize:size withTransitionCoordinator:coordinator];
    });
}

-(void)viewDidTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        CGFloat width = MAX(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        CGFloat height = MIN(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        CGFloat newHeight = height - UIDevice.jh_navigationBarHeight;
        CGFloat newWidth = width;
        self.listView.frame = CGRectMake(0, UIDevice.jh_navigationBarHeight, newWidth,newHeight);
    }else{
        CGFloat width = MIN(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        CGFloat height = MAX(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
        CGFloat newWidth = width;
        CGFloat newHeight = height - UIDevice.jh_aboveNavigationBarHeight; 
        self.listView.frame = CGRectMake(0, UIDevice.jh_aboveNavigationBarHeight, newWidth, newHeight);
    }
    [self invalidateLayout];
    [self reloadData];
    
}

@end
