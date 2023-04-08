//
//  JHUtil.h
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/17.
//

#import <Foundation/Foundation.h>

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static inline NSString* toString(id x){
    if([x isKindOfClass:[NSString class]]){
        return x;
    }else if(!x || [x isKindOfClass:[NSNull class]]){
        return @"";
    }else if([x isKindOfClass:[NSNumber class]]){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
         formatter.numberStyle = NSNumberFormatterDecimalStyle;
        return [formatter stringFromNumber:x];
    }else{
        return [x description];
    }
}

@interface JHUtil : NSObject

+ (void)performOnMainThread:(DISPATCH_NOESCAPE dispatch_block_t)block;

@end


