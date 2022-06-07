//
//  JHSystemWFViewController.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/6.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHSystemWFViewController.h"
#import "JHFrameCollectionViewCell.h"
#import "JHFoodViewModel.h"
#import "JHCollectionHeaderFooterView.h"
#import "JHMasonryCollectionViewCell.h"

@interface JHSystemWFViewController ()

@end

@implementation JHSystemWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.sectionHeadersPinToVisibleBounds = YES;
    self.viewModel = [[JHFoodViewModel alloc] init];
    //self.viewModel.isAutoLayout = YES;
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
    return @"系统瀑布流";
}

-(void)registerReusable{
    [self.listView registerClass:JHFrameCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
   // [self.listView registerClass:JHMasonryCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"scroll"]) {
//        if([self.layout respondsToSelector:@selector(shouldInvalidateLayoutForBoundsChange:)]){
//            BOOL r = [self.layout shouldInvalidateLayoutForBoundsChange:self.listView.bounds];
//            NSLog(@"r is: %d",r);
//        }
    }
}



@end
