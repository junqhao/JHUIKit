//
//  UIDevice+JHAddition.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import "UIDevice+JHAddition.h"

@implementation UIDevice (JHAddition)

+ (CGFloat)jh_statusBarHeight{
    if (@available(iOS 13.0,*)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *managr = windowScene.statusBarManager;
        return managr.statusBarFrame.size.height;
    }else{
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (UIEdgeInsets)jh_safeAreaInsets{
    if (@available(iOS 13.0,*)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets;
    }else if(@available(iOS 11.0,*)){
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets;
    }else{
        return UIEdgeInsetsZero;
    }
}

+ (CGFloat)jh_navigationBarHeight{
    return 44.0f;;
}

+(CGFloat)jh_aboveNavigationBarHeight{
    return [self jh_statusBarHeight] + [self jh_navigationBarHeight];
}

+(CGFloat)jh_tabBarHeight{
    return 49.0f;
}

+(CGFloat)jh_belowTabBarHeight{
    return [self jh_tabBarHeight] + [self jh_safeAreaInsets].bottom;
}

+ (CGFloat)jh_screenWidth{
    return CGRectGetWidth(UIScreen.mainScreen.bounds);
}

+ (CGFloat)jh_screenHeight{
    return CGRectGetHeight(UIScreen.mainScreen.bounds);;
}

+ (BOOL)isPortraitDirection{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        return YES;
    }
    return NO;
}
@end
