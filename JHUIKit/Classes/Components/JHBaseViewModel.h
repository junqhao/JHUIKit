//
//  JHBaseViewModel.h
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import <Foundation/Foundation.h>
#import "JHListViewFlowLayout.h"
@class JHBaseSectionModel;

typedef void(^CompleteBlock)(BOOL success,NSMutableArray<JHBaseSectionModel *> *datas);
typedef void(^InsertBlock)(BOOL success, NSIndexPath *indexPath, NSMutableArray<JHBaseSectionModel *> *datas);
typedef void(^DeleteBlock)(BOOL success, NSIndexPath *indexPath, NSMutableArray<JHBaseSectionModel *> *datas,BOOL isLastItemInSection);

@interface JHBaseViewModel : NSObject<JHListViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSMutableArray<__kindof JHBaseSectionModel *> *datas;
@property(nonatomic,copy) CompleteBlock complete;
@property(nonatomic,copy) InsertBlock insertBlock;
@property(nonatomic,copy) DeleteBlock deleteBlock;
@property(nonatomic,assign) BOOL isAutoLayout;

-(BOOL)requestData;

-(void)parseData:(id)rawData;
@end

