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

@end
