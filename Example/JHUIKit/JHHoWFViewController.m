//
//  JHHoWFViewController.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/7.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHHoWFViewController.h"
#import "JHCollectionHeaderFooterView.h"

@interface JHHoViewModel : JHBaseViewModel

@end

@implementation JHHoViewModel

-(BOOL)requestData
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i< 3; i++) {
        JHBaseSectionModel *secModel = [JHBaseSectionModel new];
        secModel.column = i + 1;
        int j = 0;
        if(i == 0) j = 3;
        if(i == 1) j = 19;
        if(i == 2) j = 20;
        for (int k = 0; k < j; k++) {
            JHBaseCellModel *model = [JHBaseCellModel new];
            model.cell_reuse = @"cell";
            [secModel.list addObject:model];
        }
        [arr addObject:secModel];
    }
    self.datas = arr;
    if (self.complete) {
        self.complete(YES, self.datas);
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= self.datas.count){
        return nil;
    }else{
        JHBaseSectionModel *sectionModel = self.datas[indexPath.section];
        JHBaseCellModel *model = sectionModel.list[indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.cell_reuse forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0  blue:arc4random()%256 / 255.0  alpha:1];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section >= self.datas.count){
        return 0;
    }else{
        JHBaseSectionModel *sectionModel = self.datas[section];
        return sectionModel.list.count;
    }
}

-(CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= self.datas.count){
        return CGSizeZero;
    }else{
        CGFloat w = arc4random() % 30 + 100;
        return CGSizeMake(w, w);
    }
}

-(UIEdgeInsets)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout insetsAtSection:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGFloat)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout lineSpacingAtSection:(NSInteger)section{
    return 10;
}

-(CGFloat)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout itemSpacingAtSection:(NSInteger)section{
    return 10;
}

-(NSInteger)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout columnsAtSection:(NSInteger)section{
    if(section >= self.datas.count){
        return 1;
    }else{
        JHBaseSectionModel *sectionModel = self.datas[section];
        return sectionModel.column;
    }
}

@end



@interface JHHoWFViewController ()

@end

@implementation JHHoWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.listView.frame = CGRectMake(0, (UIDevice.jh_screenHeight - 400)*.5, UIDevice.jh_screenWidth, 400);
    WeakSelf(wself);
    self.viewModel = [JHHoViewModel new];
    self.viewModel.complete = ^(BOOL success, NSMutableArray<JHBaseSectionModel *> *datas) {
        if(success){
            [wself reloadData];
        }
    };
}

-(void)registerReusable{
    [self.listView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
}

-(NSString *)title{
    return @"JH水平滚动瀑布流";
}

-(BOOL)shouldAutorotate
{
    return 0;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)dealloc{
    
}

@end
