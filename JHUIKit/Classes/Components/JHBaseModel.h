//
//  JHBaseModel.h
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import <UIKit/UIKit.h>

@interface JHBaseModel : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *photo;
@property(nonatomic,assign) NSInteger type;
@end


@class JHBaseCellModel;

@interface JHBaseSectionModel : JHBaseModel
@property(nonatomic,strong) NSMutableArray<__kindof JHBaseCellModel *> *list;
@property(nonatomic,strong) NSString *header_reuse;
@property(nonatomic,strong) NSString *footer_reuse;
@property(nonatomic,assign) NSInteger column;
@end

@interface JHBaseCellModel : JHBaseModel
@property(nonatomic,strong) NSMutableArray<__kindof JHBaseSectionModel *> *list;
@property(nonatomic,strong) NSString *cell_reuse;
@end


