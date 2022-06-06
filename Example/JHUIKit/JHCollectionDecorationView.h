//
//  JHCollectionDecorationView.h
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCollectionDecorationView : UICollectionReusableView
@property(nonatomic) UIView *tagView;
@end

@interface JHDecorationView_Type1 : JHCollectionDecorationView

@end


@interface JHDecorationView_Type2 : JHCollectionDecorationView

@end

NS_ASSUME_NONNULL_END
