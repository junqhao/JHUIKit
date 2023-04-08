//
//  JHUtil.m
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/17.
//

#import "JHUtil.h"

@implementation JHUtil

+ (void)performOnMainThread:(DISPATCH_NOESCAPE dispatch_block_t)block {
    if (NSThread.isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
@end


