//
//  UIResponder+JHRouter.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/31.
//

#import "UIResponder+JHRouter.h"

@implementation UIResponder (JHRouter)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}
@end
