//
//  JHViewController.m
//  JHUIKit
//
//  Created by junqhao on 06/04/2022.
//  Copyright (c) 2022 junqhao. All rights reserved.
//

#import "JHViewController.h"
#import "JHShouYeViewModel.h"
#import "JHCollectionHeaderFooterView.h"
#import "JHCollectionViewCell.h"
#import "JHFood.h"
#import "JHSystemWFViewController.h"
#import "JHMasonryWFViewController.h"
#import "JHFrameWFViewController.h"
#import "JHHoWFViewController.h"

@interface JHViewController ()

@end

@implementation JHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [JHShouYeViewModel new];
    self.viewModel.url = [[NSBundle mainBundle] pathForResource:@"ShowYe" ofType:@"txt"];
    WeakSelf(wself);
    self.viewModel.complete = ^(BOOL success, NSMutableArray<JHBaseSectionModel *> *datas) {
        if(success){
            [wself reloadData];
        }
    };
}

-(NSString *)title{
    return @"Demo";
}

-(void)registerReusable{
    [self.listView registerClass:JHCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}


-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if([eventName isEqualToString:@"jump"]){
        JHFood *food = [userInfo objectForKey:@"food"];
        UIViewController *controller = nil;
        switch (food.type) {
            case 0:{
                controller = [[JHSystemWFViewController alloc] init];
            }
                break;
            case 1:{
                controller = [[JHFrameWFViewController alloc] init];
            }
                break;
            case 2:
            {
                controller = [[JHMasonryWFViewController alloc] init];
            }
                break;
            case 3:{
                controller = [[JHHoWFViewController alloc] init];
            }
                break;
        }
        if(controller)
            [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
