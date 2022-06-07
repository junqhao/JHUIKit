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
    //************* important **************
    self.viewModel.isAutoLayout = YES;
    self.layout.estimatedItemSize = CGSizeMake(50, 50);
    WeakSelf(wself);
    self.viewModel.complete = ^(BOOL success, NSMutableArray<JHBaseSectionModel *> *datas) {
        if(success){
            [wself reloadData];
        }
    };
    //[self requestData];
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
           // [self insertFoodAt:indexPath];
        }else if(opt == JHMoreOptionBridge.delete){
            //[self deleteFoodAt:indexPath];
        }else{
            
        }
    }else if([eventName isEqualToString:@"updateAttributes"]){
        NSValue *value = userInfo[@"size"];
        NSIndexPath *indexPath =userInfo[@"indexPath"];
        [self.layout setCellSize:[value CGSizeValue]  atIndexPath:indexPath];
    }
}

//-(Food *)randomFood:(NSIndexPath *)indexPath{
//    Food *f = [Food new];
//    f.picName = [NSString stringWithFormat:@"food_%ld",indexPath.row % 10];
//    NSInteger randomLength = arc4random() % (kRandomAlphabet.length) + 1;
//    NSMutableString *string = [NSMutableString string];
//    for (int i = 0; i<randomLength; i++) {
//        [string appendFormat:@"%C",[kRandomAlphabet characterAtIndex:i]];
//    }
//    f.name = string;
//    return f;
//}


//-(void)insertFoodAt:(NSIndexPath *)indexPath{
//    NSMutableArray *foodSection = self.data[indexPath.section];
//    NSInteger targetRow = indexPath.row + 1;
//    if(targetRow <= foodSection.count){
//        [foodSection insertObject:[self randomFood:[NSIndexPath indexPathForRow:targetRow inSection:indexPath.section]] atIndex:targetRow];
//        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:targetRow inSection:indexPath.section]]];
//        [self.collectionView reloadData];
//    }else{
//        NSLog(@"插入位置非法");
//    }
//}
//
//-(void)deleteFoodAt:(NSIndexPath *)indexPath{
//    NSMutableArray *foodSection = self.data[indexPath.section];
//    NSInteger targetRow = indexPath.row;
//    NSInteger num = foodSection.count;
//    if(num > 0){
//        if (num > 1) {
//            [foodSection removeObjectAtIndex:targetRow];
//            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:targetRow inSection:indexPath.section]]];
//            NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
//            [set addIndex:indexPath.section];
//            [self.layout invalidateLayout];
//            //[self.collectionView reloadSections:set];
//            [self.collectionView reloadData];
//        }else{
//            //已经是最后一个元素 直接删除整个section
//            [self.data removeObjectAtIndex:indexPath.section];
//            NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
//            [set addIndex:indexPath.section];
//            [self.collectionView deleteSections:set];
//            [self.layout invalidateLayout];
//            [self.collectionView reloadData];
//        }
//    }else{
//        NSLog(@"删除位置非法");
//    }
//}

@end


@implementation JHMasonryWFViewController2

-(void)viewDidLoad{
    [super viewDidLoad];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.listView.frame = CGRectMake(0, (UIDevice.jh_screenHeight - 400)*.5, UIDevice.jh_screenWidth, 400);
}

-(BOOL)shouldAutorotate
{
    return 0;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    [super routerEventWithName:eventName userInfo:userInfo];
}

@end
