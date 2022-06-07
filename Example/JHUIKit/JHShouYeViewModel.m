//
//  JHShouYeViewModel.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/5.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHShouYeViewModel.h"
#import "JHFood.h"
#import "JHCollectionViewCell.h"
#import "JHCollectionHeaderFooterView.h"

@implementation JHShouYeViewModel

-(BOOL)requestData{
    [super requestData];
    NSData *data = [NSData dataWithContentsOfFile:self.url];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if(array){
        [self parseData:array];
    }
    return 1;
}

-(void)parseData:(id)rawData{
    NSArray *rawArray = (NSArray *)rawData;
    NSMutableArray *r = [NSMutableArray array];
    for (int i = 0; i<rawArray.count; i++) {
        JHFoodSection *sectionModel = [JHFoodSection yy_modelWithJSON:rawArray[i]];
        if(sectionModel){
            [r addObject:sectionModel];
        }
    }
    self.datas = r;
    if (self.complete) {
        self.complete(YES, self.datas);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= self.datas.count){
        return nil;
    }else{
        JHFoodSection *foodsection = self.datas[indexPath.section];
        JHFood *food = foodsection.list[indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:food.cell_reuse forIndexPath:indexPath];
        JHCollectionViewCell *jhCell = (JHCollectionViewCell *)cell;
        jhCell.label.text = food.name;
        jhCell.backgroundColor = UIColor.whiteColor;
        return cell;
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= self.datas.count){
        return nil;
    }
    JHFoodSection *foodsection = self.datas[indexPath.section];
    NSString *iden = @"";
    JHCollectionHeaderFooterView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        iden = foodsection.header_reuse;
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:iden forIndexPath:indexPath];
       reusableView.titleLabel.text = [NSString stringWithFormat:@"SectionHeader-%@", foodsection.name];
        return reusableView;
    }else{
        iden = foodsection.footer_reuse;
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:iden forIndexPath:indexPath];
        reusableView.titleLabel.text = [NSString stringWithFormat:@"SectionFooter-%@", foodsection.name];
        return  reusableView;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section >= self.datas.count){
        return 0;
    }else{
        JHFoodSection *foodsection = self.datas[section];
        return foodsection.list.count;
    }
}

-(CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(0, 60);
}

-(CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout headerSizeAtSection:(NSInteger)section{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
}

-(CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout footerSizeAtSection:(NSInteger)section{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= self.datas.count){
        
    }else{
        JHFoodSection *foodsection = self.datas[indexPath.section];
        JHFood *food = foodsection.list[indexPath.row];
        if (food) {
            [collectionView.nextResponder routerEventWithName:@"jump" userInfo:@{
                @"food":food
            }];
        }
    }
}

@end
