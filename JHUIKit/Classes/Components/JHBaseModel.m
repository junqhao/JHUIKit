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
@end


@implementation JHBaseCellModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : JHBaseSectionModel.class,
              };
}
@end
