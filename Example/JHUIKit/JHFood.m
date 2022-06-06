//
//  JHFood.m
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/5.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import "JHFood.h"

@implementation JHFood

@end

@implementation JHFoodSection
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : JHFood.class,
              };
}
@end
