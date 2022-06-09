//
//  JHFoodViewModel.h
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/5.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import <JHUIKit/JHUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InsertBlock)(BOOL success, NSIndexPath *indexPath, NSMutableArray<JHBaseSectionModel *> *datas);

typedef void(^deleteBlock)(BOOL success, NSIndexPath *indexPath, NSMutableArray<JHBaseSectionModel *> *datas,BOOL isLastItemInSection);

@interface JHFoodViewModel : JHBaseViewModel
@property(nonatomic,copy) InsertBlock insertBlock;
@property(nonatomic,copy) deleteBlock deleteBlock;

-(void)insertFoodAt:(NSIndexPath *)indexPath;

-(void)deleteFoodAt:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
