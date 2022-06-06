//
//  JHListViewFlowLayout.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/24.
//

#import "JHListViewFlowLayout.h"
//#import <JHUIKit/JHUIKit-Swift.h> //同一pod内引用swift的方式

#define JH_IsScrollDirectionVertical (self.scrollDirection == UICollectionViewScrollDirectionVertical)

@interface JHListViewFlowLayout ()
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *attributes;
@property (nonatomic, strong) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *headerAttributes;
//全部section的全部column的maxY或X
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *maxEnds;
//updates
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *insertIndexPaths;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *deleteIndexPaths;
@property (nonatomic, assign) BOOL isPinToTop;
@end

@implementation JHListViewFlowLayout

#pragma mark initial
- (instancetype)init{
    if (self = [super init]) {
        self.attributes = [[NSMutableArray alloc] init];
        self.headerAttributes = [[NSMutableArray alloc] init];
        self.maxEnds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)resetData{
    [_attributes removeAllObjects];
    [_headerAttributes removeAllObjects];
    [_maxEnds removeAllObjects];
}

#pragma mark overrides -basic

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections <= 0) {
        return;
    }
    if(self.isPinToTop){
        for (NSInteger section = 0; section < numberOfSections; section ++) {
            NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
        }
        return;
    }
    
    [self resetData];
    
    for (NSInteger section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        if(JH_IsScrollDirectionVertical){
            NSMutableDictionary *sectionItemYs = [NSMutableDictionary dictionary];
            [self.maxEnds addObject:sectionItemYs];
        }else{
            NSMutableDictionary *sectionItemXs = [NSMutableDictionary dictionary];
            [self.maxEnds addObject:sectionItemXs];
        }
        
        //sectionHeader
        UICollectionViewLayoutAttributes * headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
        if (headerAttr) {
            [_attributes addObject:headerAttr];
            [_headerAttributes addObject:headerAttr];
        }
        
        //section item
        for (NSInteger row = 0; row < numberOfItems; row ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes * itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (itemAttr) {
                [_attributes addObject:itemAttr];
            }
        }
        
        //section footer
        UICollectionViewLayoutAttributes * footerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionIndexPath];
        if (footerAttr) {
            [_attributes addObject:footerAttr];
        }
        
        //decoration view
        UICollectionViewLayoutAttributes *decoAttr = [self layoutAttributesForDecorationViewOfKind:@"" atIndexPath:sectionIndexPath];
        if(decoAttr){
            [_attributes addObject:decoAttr];
        }
    }
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //return self.attributes;
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    if (JH_IsScrollDirectionVertical) {
        CGFloat maxY = CGRectGetMaxY(rect);
        CGFloat minY = CGRectGetMinY(rect);
        for (UICollectionViewLayoutAttributes *attr in _attributes) {
            if(CGRectGetMaxY(attr.frame) >= minY && CGRectGetMinY(attr.frame) <= maxY){
                [results addObject:attr];
            }
        }
    }else{
        CGFloat maxX = CGRectGetMaxX(rect);
        CGFloat minX = CGRectGetMinX(rect);
        for (UICollectionViewLayoutAttributes *attr in _attributes) {
            if(CGRectGetMaxX(attr.frame) >= minX && CGRectGetMinX(attr.frame) <= maxX){
                [results addObject:attr];
            }
        }
    }
    return results;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    //return NO;
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    if([self getPinToTop]){
        self.isPinToTop = YES;
        return YES;
    }else{
        self.isPinToTop = NO;
    }
    
    return NO;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (JH_IsScrollDirectionVertical) {
        return [self layoutAttributesForItemAtIndexPathInVertical:indexPath];
    }else{
        return [self layoutAttributesForItemAtIndexPathInHorizontal:indexPath];
    }
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if (JH_IsScrollDirectionVertical) {
        return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPathVertical:indexPath];
    }else{
        return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPathHorizontal:indexPath];
    }
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    NSString *className = [self jhListViewFlowLayoutDecorationViewClassAtSection:indexPath.section];
    if(![className isKindOfClass:[NSString class]]) return nil;
    Class cls = NSClassFromString(className);
    if(!cls) return nil;
    [self registerClass:cls forDecorationViewOfKind:className];
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:className withIndexPath:indexPath];
    CGFloat x = 0.0,y = 0.0;
    NSInteger section = indexPath.section;
    if(section > 0){
        y = [self getSectionMaxYinSection:section-1];
    }
    attr.frame = CGRectMake(x, y, self.contentWidth, [self getSectionMaxYinSection:section] - y);
    attr.zIndex = -1;
    return attr;
}

#pragma mark overrides -updates
//-(void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems{
//    [super prepareForCollectionViewUpdates:updateItems];
//    //删除整个section时updateItems.count==1,row = NSInteger.MAX
////    for (UICollectionViewUpdateItem *item in updateItems) {
////        NSLog(@"before:%@ after:%@",item.indexPathBeforeUpdate,item.indexPathAfterUpdate);
////    }
//    self.deleteIndexPaths = [NSMutableArray array];
//    self.insertIndexPaths = [NSMutableArray array];
//    
//    for (UICollectionViewUpdateItem *update in updateItems)
//    {
//        if (update.updateAction == UICollectionUpdateActionDelete)
//        {
//            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
//        }
//        else if (update.updateAction == UICollectionUpdateActionInsert)
//        {
//            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
//        }
//    }
//}
//
//-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
//    UICollectionViewLayoutAttributes *attributes = [self findItemAttributes:itemIndexPath];
//    if ([self.insertIndexPaths containsObject:itemIndexPath])
//    {
//        if (!attributes){
//            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        }
//        attributes.alpha = 0.0;
//        attributes.transform = CGAffineTransformMakeScale(.5, .5);
//    }
//    return attributes;
//}
//
//-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
//    UICollectionViewLayoutAttributes *attributes = [self findItemAttributes:itemIndexPath];
//    if ([self.deleteIndexPaths containsObject:itemIndexPath])
//    {
//        if (!attributes){
//            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        }
//        attributes.alpha = 0.0;
//        attributes.transform = CGAffineTransformMakeScale(.5, .5);
//    }
//    return attributes;
//}

-(void)finalizeCollectionViewUpdates{
    [super finalizeCollectionViewUpdates];
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

#pragma mark custom overrides
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPathInVertical:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if(CGSizeEqualToSize(CGSizeZero,self.estimatedItemSize)){
        CGSize delegate_size = [self jhListViewFlowLayoutItemSizeForIndexPath:indexPath];
        if (CGSizeEqualToSize(delegate_size, CGSizeZero)) {
            return nil;
        }else{
            size = delegate_size;
        }
    }else{
        //autolayout
        size = self.estimatedItemSize;
    }
    
    //optimize reuse
    UICollectionViewLayoutAttributes *attr = [self findItemAttributes:indexPath];
    if(!attr){
        attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    
    CGFloat x = 0.0,y = 0.0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger columns = [self jhListViewFlowLayoutColumnsAtSection:section];
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    CGFloat itemSpacing = [self jhListViewFlowLayoutItemSpacingAtSection:section];
    CGFloat lineSpacing = [self jhListViewFlowLayoutLineSpacingAtSection:section];
    
    CGSize headerSize = [self jhListViewFlowLayoutHeaderSizeAtSection:section];
    if (section == 0) {
        y += headerSize.height + insets.top;
    }else{
        y += headerSize.height + insets.top + [self getSectionMaxYinSection:section-1];
    }
    
    //查找当前section中itemY的最小值和对应的列
    NSMutableDictionary *sectionItemYs = self.maxEnds[section];
    CGFloat minY = [[sectionItemYs objectForKey:@(0)] floatValue];
    NSInteger minCol = 0;
    
    for (int col = 0; col < columns; col ++) {
        if(row == 0){ //新section 重置y
            [sectionItemYs setObject:@(y) forKey:@(col)];
            minY = y;
        }else{
            //找到Y最小的一列
            CGFloat colY = [[sectionItemYs objectForKey:@(col)] floatValue];
            if(colY < minY){
                minY = colY;
                minCol = col;
            }
        }
    }
    
    size.width = (self.contentWidth - insets.left - insets.right - itemSpacing * (columns - 1)) / columns;
    size.width = floor(size.width); //avoid crash
    x = insets.left + (size.width + itemSpacing) * minCol;
    y = minY + ((columns > row) ? 0 : lineSpacing);
    
    [sectionItemYs setObject:@(y + size.height) forKey:@(minCol)];
    attr.frame = CGRectMake(x, y, size.width, size.height);
    
    //set real size
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *preferAttr = nil;
    if ([cell respondsToSelector:@selector(preferredLayoutAttributesFittingAttributes:)]) {
        preferAttr = [cell preferredLayoutAttributesFittingAttributes:attr];
    }
   
    if(preferAttr){
        CGFloat realHeight = preferAttr.frame.size.height;
        attr.frame = CGRectMake(x, y, size.width, realHeight);
        [sectionItemYs setObject:@(y + realHeight) forKey:@(minCol)];
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPathInHorizontal:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if(CGSizeEqualToSize(CGSizeZero,self.estimatedItemSize)){
        CGSize delegate_size = [self jhListViewFlowLayoutItemSizeForIndexPath:indexPath];
        if (CGSizeEqualToSize(delegate_size, CGSizeZero)) {
            return nil;
        }else{
            size = delegate_size;
        }
    }else{
        //autolayout
        size = self.estimatedItemSize;
    }
    
    //optimize reuse
    UICollectionViewLayoutAttributes *attr = [self findItemAttributes:indexPath];
    if(!attr){
        attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    
    CGFloat x = 0.0,y = 0.0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger columns = [self jhListViewFlowLayoutColumnsAtSection:section];
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    CGFloat itemSpacing = [self jhListViewFlowLayoutItemSpacingAtSection:section];
    CGFloat lineSpacing = [self jhListViewFlowLayoutLineSpacingAtSection:section];
    
    CGSize headerSize = [self jhListViewFlowLayoutHeaderSizeAtSection:section];
    if (section == 0) {
        x += headerSize.width + insets.left;
    }else{
        x += headerSize.width + insets.left + [self getSectionMaxXinSection:section-1];
    }
    
    //查找当前section中itemX的最小值和对应的行
    NSMutableDictionary *sectionItemXs = self.maxEnds[section];
    CGFloat minX = [[sectionItemXs objectForKey:@(0)] floatValue];
    NSInteger minCol = 0;
    
    for (int col = 0; col < columns; col ++) {
        if(row == 0){ //新section 重置x
            [sectionItemXs setObject:@(x) forKey:@(col)];
            minX = x;
        }else{
            //找到X最小的一列
            CGFloat colX = [[sectionItemXs objectForKey:@(col)] floatValue];
            if(colX < minX){
                minX = colX;
                minCol = col;
            }
        }
    }
    
    size.height = (self.contentHeight - insets.top - insets.bottom - itemSpacing * (columns - 1)) / columns;
    size.height = floor(size.height);
    y = insets.top + (size.height + itemSpacing) * minCol;
    x = minX + ((columns > row) ? 0 : lineSpacing);
    
    [sectionItemXs setObject:@(x + size.width) forKey:@(minCol)];
    attr.frame = CGRectMake(x, y, size.width, size.height);
    
    //set real size
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *preferAttr = nil;
    if ([cell respondsToSelector:@selector(preferredLayoutAttributesFittingAttributes:)]) {
        preferAttr = [cell preferredLayoutAttributesFittingAttributes:attr];
    }
   
    if(preferAttr){
        CGFloat realWidth = preferAttr.frame.size.height;
        attr.frame = CGRectMake(x, y, realWidth, size.height);
        [sectionItemXs setObject:@(x + realWidth) forKey:@(minCol)];
    }
    
    return attr;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPathVertical:(NSIndexPath *)indexPath{
    BOOL isHeader = [elementKind isEqualToString:UICollectionElementKindSectionHeader];
    NSInteger section = indexPath.section;
    CGFloat x = 0.0,y = 0.0;
    CGSize size = CGSizeZero;
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    if (isHeader) {
        size = [self jhListViewFlowLayoutHeaderSizeAtSection:section];
    } else{
        size = [self jhListViewFlowLayoutFooterSizeAtSection:section];
    }
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        return nil;
    }
    CGFloat maxWidth = self.contentWidth - insets.left - insets.right;
    size.width = (size.width > maxWidth)? maxWidth : size.width;
    x = insets.left;
    
    //从缓存中读取已存在的attr,防止zIndex丢失
    UICollectionViewLayoutAttributes *attr = nil;
    if(section < self.headerAttributes.count && isHeader){
        attr = self.headerAttributes[section];
    }else{
        attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    
    //footer
    if (!isHeader) {
        y = [self getItemMaxYinSection:section] + insets.bottom;
    }else{
        y = [self getHeaderY:attr];
        //需要同时处理上一个header的位置
        if(section-1 < self.headerAttributes.count && section > 0){
            UICollectionViewLayoutAttributes *lastAttr = self.headerAttributes[section-1];
            CGFloat y = [self getHeaderY:lastAttr];
            lastAttr.frame = CGRectMake(x, y, size.width, size.height);
        }
    }

    attr.frame = CGRectMake(x, y, size.width, size.height);
    return attr;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPathHorizontal:(NSIndexPath *)indexPath{
    BOOL isHeader = [elementKind isEqualToString:UICollectionElementKindSectionHeader];
    NSInteger section = indexPath.section;
    CGFloat x = 0.0,y = 0.0;
    CGSize size = CGSizeZero;
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    if (isHeader) {
        size = [self jhListViewFlowLayoutHeaderSizeAtSection:section];
    } else{
        size = [self jhListViewFlowLayoutHeaderSizeAtSection:section];
    }
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        return nil;
    }
    CGFloat maxHeight = self.contentHeight - insets.top - insets.bottom;
    size.height = (size.height > maxHeight)? maxHeight : size.height;
    y = insets.top;
    
    //从缓存中读取已存在的attr,防止zIndex丢失
    UICollectionViewLayoutAttributes *attr = nil;
    if(section < self.headerAttributes.count && isHeader){
        attr = self.headerAttributes[section];
    }else{
        attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    
    //footer
    if (!isHeader) {
        x = [self getItemMaxXinSection:section] + insets.right;
    }else{
        x = [self getHeaderX:attr];
        //需要同时处理上一个header的位置
        if(section-1 < self.headerAttributes.count && section > 0){
            UICollectionViewLayoutAttributes *lastAttr = self.headerAttributes[section-1];
            CGFloat x = [self getHeaderX:lastAttr];
            lastAttr.frame = CGRectMake(x, y, size.width, size.height);
        }
    }

    attr.frame = CGRectMake(x, y, size.width, size.height);
    return attr;
}


#pragma mark convinient
///获取header位置
-(CGFloat)getHeaderY:(UICollectionViewLayoutAttributes *)attr{
    NSInteger section = attr.indexPath.section;
    CGFloat y = (section == 0)? 0 : [self getSectionMaxYinSection:section-1];
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat maxY = [self getSectionMaxYinSection:section];
    CGFloat headerHeight = [self jhListViewFlowLayoutHeaderSizeAtSection:section].height;
    CGFloat footerHeight = [self jhListViewFlowLayoutFooterSizeAtSection:section].height;
    CGFloat pinMaxY = maxY - headerHeight - footerHeight;//应该减去header footer本身的占位高度
    BOOL isPinToTop = [self jhListViewFlowLayoutHeaderPinToTopAtSection:section];
    if (isPinToTop) {
        if(offsetY <= y){ //应保持在最初的位置
            attr.zIndex = 0;
            //NSLog(@"\n 分支1 section:%ld,offsetY:%.2f,y:%.2f,maxY:%.2f",section,offsetY,y,pinMaxY);
        }else if(offsetY >y && offsetY <= pinMaxY){ //吸顶的位置
            //NSLog(@"\n 分支2 section:%ld,offsetY:%.2f,y:%.2f,maxY:%.2f",section,offsetY,y,pinMaxY);
            y = offsetY;
            attr.zIndex = 1024;
        }
        else{ //移动上去
            //NSLog(@"\n 分支3 section:%ld,offsetY:%.2f,y:%.2f,maxY:%.2f",section,offsetY,y,pinMaxY);
            y = offsetY - (offsetY - pinMaxY);
            attr.zIndex = 0;
        }
    }
    return y;
}

-(CGFloat)getHeaderX:(UICollectionViewLayoutAttributes *)attr{
    NSInteger section = attr.indexPath.section;
    CGFloat x = (section == 0)? 0 : [self getSectionMaxXinSection:section-1];
    CGFloat offsetX = self.collectionView.contentOffset.x;
    CGFloat maxX = [self getSectionMaxXinSection:section];
    CGFloat headerWidth = [self jhListViewFlowLayoutHeaderSizeAtSection:section].width;
    CGFloat footerWidth = [self jhListViewFlowLayoutFooterSizeAtSection:section].width;
    CGFloat pinMaxX = maxX - headerWidth - footerWidth;//应该减去header footer本身的占位高度
    BOOL isPinToTop = [self jhListViewFlowLayoutHeaderPinToTopAtSection:section];
    if (isPinToTop) {
        if(offsetX <= x){ //应保持在最初的位置
            attr.zIndex = 0;
        }else if(offsetX >x && offsetX <= pinMaxX){ //吸顶的位置
            x = offsetX;
            attr.zIndex = 1024;
        }
        else{ //移动上去
            x = offsetX - (offsetX - pinMaxX);
            attr.zIndex = 0;
        }
    }
    return x;
}

- (UICollectionViewLayoutAttributes *)findItemAttributes:(NSIndexPath *)indexPath{
    for (UICollectionViewLayoutAttributes *attr in self.attributes) {
        if(attr.representedElementCategory == UICollectionElementCategoryCell && [attr.indexPath compare:indexPath] == NSOrderedSame){
            return attr;
        }
    }
    return nil;
}

/// 计算每个section中item的最大Y
- (CGFloat)getItemMaxYinSection:(NSInteger)section{
    NSInteger maxCount = self.maxEnds.count;
    if(maxCount == 0) return 0;
    if(section >= maxCount) section = maxCount;
    if(section < 0) section = 0;
    NSDictionary<NSNumber *,NSNumber *> *sectionYs = self.maxEnds[section];
    __block CGFloat maxY = [sectionYs objectForKey:@(0)].floatValue;
    [sectionYs enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        CGFloat y = [obj floatValue];
        if(y > maxY){
            maxY = y;
        }
    }];
    return maxY;
}

/// 计算每个section中item的最大X
- (CGFloat)getItemMaxXinSection:(NSInteger)section{
    NSInteger maxCount = self.maxEnds.count;
    if(maxCount == 0) return 0;
    if(section >= maxCount) section = maxCount;
    if(section < 0) section = 0;
    NSDictionary<NSNumber *,NSNumber *> *sectionXs = self.maxEnds[section];
    __block CGFloat maxX = [sectionXs objectForKey:@(0)].floatValue;
    [sectionXs enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        CGFloat x = [obj floatValue];
        if(x > maxX){
            maxX = x;
        }
    }];
    return maxX;
}

/// 计算每个section的最大Y，包含footer
- (CGFloat)getSectionMaxYinSection:(NSInteger)section{
    NSInteger maxCount = self.maxEnds.count;
    if(maxCount == 0) return 0;
    if(section >= maxCount) section = maxCount;
    if(section < 0) section = 0;
    CGSize sectionFooterSize = [self jhListViewFlowLayoutFooterSizeAtSection:section];
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    return [self getItemMaxYinSection:section] + sectionFooterSize.height + insets.bottom;
}

/// 计算每个section的最大X，包含footer
- (CGFloat)getSectionMaxXinSection:(NSInteger)section{
    NSInteger maxCount = self.maxEnds.count;
    if(maxCount == 0) return 0;
    if(section < 0) section = 0;
    if(section >= maxCount) section = maxCount;
    CGSize sectionFooterSize = [self jhListViewFlowLayoutFooterSizeAtSection:section];
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    return [self getItemMaxXinSection:section] + sectionFooterSize.width + insets.right;
}

/// 返回contentHeight
- (CGFloat)contentHeight{
    if (JH_IsScrollDirectionVertical) {
        NSInteger lastSection = self.maxEnds.count - 1;
        if (lastSection < 0) {
            lastSection = 0;
        }
        _contentHeight = [self getSectionMaxYinSection:lastSection];
        CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.frame);
        if(_contentHeight < collectionViewHeight){
            _contentHeight = collectionViewHeight;
        }
    }else{
        _contentHeight = CGRectGetHeight(self.collectionView.frame) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;
    }
    return _contentHeight;
}

/// 返回contentWidth
- (CGFloat)contentWidth{
    if (JH_IsScrollDirectionVertical) {
        _contentWidth =  CGRectGetWidth(self.collectionView.frame) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    }else{
        NSInteger lastSection = self.maxEnds.count - 1;
        if (lastSection < 0) {
            lastSection = 0;
        }
        _contentWidth = [self getSectionMaxXinSection:lastSection];
        CGFloat collectionViewWidth = CGRectGetHeight(self.collectionView.frame);
        if(_contentWidth < collectionViewWidth){
            _contentWidth = collectionViewWidth;
        }
    }
    return _contentWidth;
}

-(BOOL)getPinToTop{
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections <= 0) {
        return 0;
    }
    BOOL r = 0;
    for (int i =0; i<self.collectionView.numberOfSections; i++) {
        r = [self jhListViewFlowLayoutHeaderPinToTopAtSection:i];
        if(r){
            break;
        }
    }
    return r;
}

#pragma mark delegate

- (NSInteger)jhListViewFlowLayoutColumnsAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:columnsAtSection:)]){
        return [self.delegate jh_listView:self.collectionView columnsAtSection:section];
    }
    return 1;
}

- (CGSize)jhListViewFlowLayoutHeaderSizeAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:headerSizeAtSection:)]){
        return [self.delegate jh_listView:self.collectionView headerSizeAtSection:section];
    }
    return CGSizeZero;
}

- (CGSize)jhListViewFlowLayoutFooterSizeAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:footerSizeAtSection:)]){
        return [self.delegate jh_listView:self.collectionView footerSizeAtSection:section];
    }
    return CGSizeZero;
}

- (CGSize)jhListViewFlowLayoutItemSizeForIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:itemSizeForIndexPath:)]){
        return [self.delegate jh_listView:self.collectionView itemSizeForIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (UIEdgeInsets)jhListViewFlowLayoutInsetsAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:insetsAtSection:)]){
        return [self.delegate jh_listView:self.collectionView insetsAtSection:section];
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)jhListViewFlowLayoutLineSpacingAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:lineSpacingAtSection:)]){
        return [self.delegate jh_listView:self.collectionView lineSpacingAtSection:section];
    }
    return 0;
}

- (CGFloat)jhListViewFlowLayoutItemSpacingAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:itemSpacingAtSection:)]){
        return [self.delegate jh_listView:self.collectionView itemSpacingAtSection:section];
    }
    return 0;
}

- (BOOL)jhListViewFlowLayoutHeaderPinToTopAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:headerPinToTopAtSection:)]){
        return [self.delegate jh_listView:self.collectionView headerPinToTopAtSection:section];
    }
    return 0;
}

- (NSString *)jhListViewFlowLayoutDecorationViewClassAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:decorationViewClassAtSection:)]){
        return [self.delegate jh_listView:self.collectionView decorationViewClassAtSection:section];
    }
    return nil;
}
@end