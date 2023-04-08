//
//  JHMasonryWFViewController.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/6.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHMasonryWFViewController.h"
#import "JHMasonryCollectionViewCell.h"
#import "JHFoodViewModel.h"
#import "JHCollectionHeaderFooterView.h"

@interface JHMasonryWFViewController ()

@end

@implementation JHMasonryWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[JHFoodViewModel alloc] init];
    self.viewModel.url = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"txt"];
    self.viewModel.isAutoLayout = YES;
    //************* important **************
    self.layout.estimatedItemSize = CGSizeMake(50, 50);
    WeakSelf(wself);
    self.viewModel.complete = ^(BOOL success, NSMutableArray<JHBaseSectionModel *> *datas) {
        if(success){
            [wself reloadData];
        }
    };
    self.viewModel.insertBlock = ^(BOOL success, NSIndexPath * _Nonnull indexPath, NSMutableArray<JHBaseSectionModel *> * _Nonnull datas) {
        if(success){
            CGPoint offset = wself.listView.contentOffset;
            [wself.listView performBatchUpdates:^{
                [wself.listView insertItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                //防止不调用cellforitem 导致indexpath错误
                [wself reloadData];
                wself.listView.contentOffset = offset;
            }];
        }
    };
    self.viewModel.deleteBlock = ^(BOOL success, NSIndexPath * _Nonnull indexPath, NSMutableArray<JHBaseSectionModel *> * _Nonnull datas, BOOL isLastItemInSection) {
        if(!success) return;
        CGPoint offset = wself.listView.contentOffset;
        [wself.listView performBatchUpdates:^{
            if(!isLastItemInSection){
                [wself.listView deleteItemsAtIndexPaths:@[indexPath]];
            }else{
                NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
                [set addIndex:indexPath.section];
                [wself.listView deleteSections:set];
            }
        } completion:^(BOOL finished) {
            [wself reloadData];
            if (offset.y < wself.listView.contentSize.height) {
                wself.listView.contentOffset = offset;
            }
        }];
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

-(NSString *)title{
    return @"JH瀑布流-自适应高度";
}

-(void)registerReusable{
    [self.listView registerClass:JHMasonryCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.listView registerClass:JHCollectionHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"optSelected"]) {
        NSInteger opt = [userInfo[@"opt"] integerValue];
        NSIndexPath *indexPath = userInfo[@"indexPath"];
        if (opt == JHMoreOptionBridge.insert) {
            [self.viewModel insertFoodAt:indexPath];
        }else if(opt == JHMoreOptionBridge.delete){
            [self.viewModel deleteFoodAt:indexPath];
        }else{
            
        }
    }else if([eventName isEqualToString:@"updateAttributes"]){
        NSValue *value = userInfo[@"size"];
        NSIndexPath *indexPath =userInfo[@"indexPath"];
        [self.layout setActualCellSize:[value CGSizeValue]  atIndexPath:indexPath];
    }
}



@end
