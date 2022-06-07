//
//  JHBaseModel.m
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import "JHBaseModel.h"

@implementation JHBaseModel

@end

@implementation JHBaseSectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : JHBaseCellModel.class,
              };
}

-(NSMutableArray<__kindof JHBaseCellModel *> *)list{
    if(!_list){
        _list = [NSMutableArray array];
    }
    return _list;
}
@end


@implementation JHBaseCellModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : JHBaseSectionModel.class,
              };
}

-(NSMutableArray<__kindof JHBaseSectionModel *> *)list{
    if(!_list){
        _list = [NSMutableArray array];
    }
    return _list;
}
@end
