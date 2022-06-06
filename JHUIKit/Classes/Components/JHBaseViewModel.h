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

@interface JHBaseViewModel : NSObject<JHListViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSMutableArray<__kindof JHBaseSectionModel *> *datas;
@property(nonatomic,copy) CompleteBlock complete;
@property(nonatomic,assign) BOOL isAutoLayout;

-(BOOL)requestData;

-(void)parseData:(id)rawData;
@end

