//
//  UIDevice+JHAddition.h
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (JHAddition)

///已包含safeArea
+ (CGFloat)jh_statusBarHeight;

+ (UIEdgeInsets)jh_safeAreaInsets;

+ (CGFloat)jh_navigationBarHeight;

+ (CGFloat)jh_tabBarHeight;

///navigationBarHeight + statusBarHeight
+ (CGFloat)jh_aboveNavigationBarHeight;

///tabBarHeight + safeAreaInsets.bottom
+ (CGFloat)jh_belowTabBarHeight;

@end

NS_ASSUME_NONNULL_END
