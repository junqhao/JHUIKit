//
//  JHFrameWFViewController.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/6.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHFrameWFViewController.h"
#import "JHFrameCollectionViewCell.h"
#import "JHFoodViewModel.h"
#import "JHCollectionHeaderFooterView.h"

@interface JHFrameWFViewController ()

@end

@implementation JHFrameWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[JHFoodViewModel alloc] init];
    self.viewModel.url = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"txt"];
    WeakSelf(wself);
    self.viewModel.complete = ^(BOOL success, NSMutableArray<JHBaseSectionModel *> *datas) {
        if(success){
            [wself reloadData];
        }
    };
    [self requestData];
}

-(NSString *)title{
    return @"JH瀑布流-固定高度";
}

-(void)registerReusable{
    [self.listView registerClass:JHFrameCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}


@end
