//
//  JHFoodViewModel.h
//  JHUIKit_Example
//
//  Created by Junqing Hao on 2022/6/5.
//  Copyright © 2022 junqhao. All rights reserved.
//

#import <JHUIKit/JHUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFoodViewModel : JHBaseViewModel

-(void)insertFoodAt:(NSIndexPath *)indexPath;

-(void)deleteFoodAt:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
