//
//  JHFoodViewModel.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/5.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHFoodViewModel.h"
#import "JHFood.h"
#import <YYModel/YYModel.h>
#import "JHFrameCollectionViewCell.h"
#import "JHMasonryCollectionViewCell.h"
#import "JHCollectionHeaderFooterView.h"
#import "JHCollectionDecorationView.h"

@implementation JHFoodViewModel

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

//////////////////// default system layout need blow //////////////////////////////
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self jh_listView:collectionView layout:collectionViewLayout itemSizeForIndexPath:indexPath];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [self jh_listView:collectionView layout:collectionViewLayout insetsAtSection:section];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self jh_listView:collectionView layout:collectionViewLayout lineSpacingAtSection:section];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self jh_listView:collectionView layout:collectionViewLayout itemSpacingAtSection:section];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self jh_listView:collectionView layout:collectionViewLayout footerSizeAtSection:section];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self jh_listView:collectionView layout:collectionViewLayout headerSizeAtSection:section];
}

////////////////////// jhflowlayout need below /////////////////////////////

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= self.datas.count){
        return nil;
    }else{
        JHFoodSection *foodsection = self.datas[indexPath.section];
        JHFood *food = foodsection.list[indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:food.cell_reuse forIndexPath:indexPath];
        if(self.isAutoLayout){
            JHMasonryCollectionViewCell *jhCell = (JHMasonryCollectionViewCell *)cell;
            [jhCell setIndexPath:indexPath];
            [jhCell setData:food];
        }else{
            JHFrameCollectionViewCell *jhCell = (JHFrameCollectionViewCell *)cell;
            [jhCell setData:food];
        }
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
        if(iden.length == 0) return nil;
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:iden forIndexPath:indexPath];
       reusableView.titleLabel.text = [NSString stringWithFormat:@"SectionHeader-%@", foodsection.name];
        return reusableView;
    }else{
        iden = foodsection.footer_reuse;
        if(iden.length == 0) return nil;
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
    if(indexPath.section >= self.datas.count){
        return CGSizeZero;
    }else{
        JHFoodSection *foodsection = self.datas[indexPath.section];
        JHFood *food = foodsection.list[indexPath.row];
        CGFloat radio = 1.0;
        if(foodsection.column > 0){
            radio /= foodsection.column;
        }else{
            foodsection.column = 1;
        }
        CGFloat cellWidth = (collectionView.frame.size.width - 20 - (foodsection.column -1) * 10) * radio;
        CGFloat maxW = cellWidth - 20;
        CGFloat height = [JHFrameCollectionViewCell getHeight:food maxW:maxW];
        return CGSizeMake(cellWidth, height);
    }
}

-(CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout headerSizeAtSection:(NSInteger)section{
    JHFoodSection *foodsection = self.datas[section];
    if (foodsection.header_reuse.length == 0) {
        return CGSizeZero;
    }
    
    if(layout.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        return CGSizeMake(30,CGRectGetHeight(collectionView.frame));
    }
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 50, 30);
}

-(CGSize)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout footerSizeAtSection:(NSInteger)section{
    JHFoodSection *foodsection = self.datas[section];
    if (foodsection.footer_reuse.length == 0) {
        return CGSizeZero;
    }
    
    if(layout.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        return CGSizeMake(30,CGRectGetHeight(collectionView.frame));
    }
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 50, 30);
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

-(BOOL)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout headerPinToTopAtSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 0;
}

-(NSInteger)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout columnsAtSection:(NSInteger)section{
    if(section >= self.datas.count){
        return 1;
    }else{
        JHFoodSection *foodsection = self.datas[section];
        return foodsection.column;
    }
}

-(NSString *)jh_listView:(UICollectionView *)collectionView layout:(JHListViewFlowLayout *)layout decorationViewClassAtSection:(NSInteger)section{
    if(section == 0){
        return @"JHDecorationView_Type1";
    }else if(section == 1){
        return @"JHDecorationView_Type2";
    }else{
        return nil;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //[scrollView.nextResponder routerEventWithName:@"scroll" userInfo:@{}];
}

-(void)insertFoodAt:(NSIndexPath *)indexPath{
    JHFoodSection *foodsection = self.datas[indexPath.section];
    NSInteger targetRow = indexPath.row + 1;
    if(targetRow <= foodsection.list.count){
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:targetRow inSection:indexPath.section];
        JHFood *food = [self randomFood:targetIndexPath];
        [foodsection.list insertObject:food atIndex:targetRow];
        if (self.insertBlock) {
            self.insertBlock(1, targetIndexPath, self.datas);
        }
    }else{
        NSLog(@"插入位置非法");
    }
}

-(void)deleteFoodAt:(NSIndexPath *)indexPath{
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
}

-(JHFood *)randomFood:(NSIndexPath *)indexPath{
    JHFood *f = [JHFood new];
    f.cell_reuse = @"cell";
    f.photo = @"sold_out";
    f.name = [NSString stringWithFormat:@"插入一条数据 插入位置 indexpath:%ld-%ld",indexPath.section,indexPath.row];
    return f;
}
@end
