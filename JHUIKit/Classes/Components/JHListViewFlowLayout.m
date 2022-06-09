//
//  JHListViewFlowLayout.m
//  JHUIKit
//
//  Created by junqhao on 2022/5/24.
//

#import "JHListViewFlowLayout.h"
#import <objc/runtime.h>
//#import <JHUIKit/JHUIKit-Swift.h> //同一pod内引用swift的方式

static char *COL = "JHCOL";

#define JH_IsScrollDirectionVertical (self.scrollDirection == UICollectionViewScrollDirectionVertical)

@implementation UICollectionViewLayoutAttributes (JHAddition)

-(void)setCol:(NSInteger)col{
    objc_setAssociatedObject(self, &COL, [NSNumber numberWithInteger:col], OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)col{
    id _col = objc_getAssociatedObject(self, &COL);
    if(_col){
        return [_col integerValue];
    }else{
        return -1;
    }
}

@end

@interface JHListViewFlowLayout ()
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) NSMutableArray <NSMutableArray<__kindof UICollectionViewLayoutAttributes *>*> *groupedAttributes;
@property (nonatomic, strong) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *headerAttributes;
@property (nonatomic, strong) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *footerAttributes;
@property (nonatomic, strong) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *decorationAttributes;

//全部section的全部column的maxY或X
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *maxEnds;
//cell在autolayout后的真实size
@property (nonatomic,strong) NSMutableDictionary *actualItemSizes;

//updates
//@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *insertIndexPaths;
//@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *deleteIndexPaths;

@end

@implementation JHListViewFlowLayout

#pragma mark initial
- (instancetype)init{
    if (self = [super init]) {
        self.groupedAttributes = [[NSMutableArray alloc] init];
        self.headerAttributes = [[NSMutableArray alloc] init];
        self.footerAttributes = [[NSMutableArray alloc] init];
        self.decorationAttributes = [[NSMutableArray alloc] init];
        self.maxEnds = [[NSMutableArray alloc] init];
        self.actualItemSizes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)resetData{
    [_groupedAttributes removeAllObjects];
    [_headerAttributes removeAllObjects];
    [_footerAttributes removeAllObjects];
    [_decorationAttributes removeAllObjects];
    [_maxEnds removeAllObjects];
}

#pragma mark overrides -basic

-(void)invalidateLayout{
    [super invalidateLayout];
}

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections <= 0) {
        return;
    }
    
    [self resetData];
    
    for (NSInteger section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        NSMutableDictionary *sectionItemEnds = [NSMutableDictionary dictionary];
        [self.maxEnds addObject:sectionItemEnds];
        
        NSMutableArray *group = [NSMutableArray array];
        [self.groupedAttributes addObject:group];
        
        //sectionHeader
        UICollectionViewLayoutAttributes * headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
        if (headerAttr) {
            [group addObject:headerAttr];
            [_headerAttributes addObject:headerAttr];
        }
        
        //section item
        for (NSInteger row = 0; row < numberOfItems; row ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes * itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (itemAttr) {
                [group addObject:itemAttr];
            }
        }
        
        //section footer
        UICollectionViewLayoutAttributes * footerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionIndexPath];
        if (footerAttr) {
            [group addObject:footerAttr];
            [_footerAttributes addObject:footerAttr];
        }
        
        //decoration view
        UICollectionViewLayoutAttributes *decoAttr = [self layoutAttributesForDecorationViewOfKind:@"" atIndexPath:sectionIndexPath];
        if(decoAttr){
            [group addObject:decoAttr];
            [_decorationAttributes addObject:decoAttr];
        }
    }
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //return self.attributes;
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableArray *group in self.groupedAttributes) {
        if (JH_IsScrollDirectionVertical) {
            CGFloat maxY = CGRectGetMaxY(rect);
            CGFloat minY = CGRectGetMinY(rect);
            for (UICollectionViewLayoutAttributes *attr in group) {
                if(CGRectGetMaxY(attr.frame) >= minY && CGRectGetMinY(attr.frame) <= maxY){
                    [results addObject:attr];
                }
            }
        }else{
            CGFloat maxX = CGRectGetMaxX(rect);
            CGFloat minX = CGRectGetMinX(rect);
            for (UICollectionViewLayoutAttributes *attr in group) {
                if(CGRectGetMaxX(attr.frame) >= minX && CGRectGetMinX(attr.frame) <= maxX){
                    [results addObject:attr];
                }
            }
        }
    }
    return results;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    //return NO;
    if([self getPinToTop]){
        return YES;
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
    UICollectionViewLayoutAttributes *attr = [self findDecorationAttributes:indexPath];
    if(!attr){
        attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:className withIndexPath:indexPath];
    }
    [self registerClass:cls forDecorationViewOfKind:className];
    CGFloat x = 0.0,y = 0.0;
    NSInteger section = indexPath.section;
    y = [self getMinYinSection:section];
    attr.frame = CGRectMake(x, y, self.contentWidth, [self getMaxYinSection:section withFooter:YES] - y);
    attr.zIndex = -1;
    return attr;
}

#pragma mark custom overrides
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPathInVertical:(NSIndexPath *)indexPath{
    //optimize reuse
    UICollectionViewLayoutAttributes *attr = [self findItemAttributes:indexPath];
    if(attr){
        [self setActualSize:attr isInit:NO];
        return attr;
    }else{
        attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    
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
        y += headerSize.height + insets.top + [self getMinYinSection:section];
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
    
    attr.col = minCol;
    attr.frame = CGRectMake(x, y, size.width, size.height);
    
    //set real size
    [self setActualSize:attr isInit:YES];
    [sectionItemYs setObject:@(y + attr.frame.size.height) forKey:@(minCol)];
    
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPathInHorizontal:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [self findItemAttributes:indexPath];
    if(attr){
        [self setActualSize:attr isInit:NO];
        return attr;
    }else{
        attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    
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
        x += headerSize.width + insets.left + [self getMinXinSection:section];
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
    
    attr.col = minCol;
    attr.frame = CGRectMake(x, y, size.width, size.height);
    
    [self setActualSize:attr isInit:YES];
    [sectionItemXs setObject:@(x + attr.frame.size.width) forKey:@(minCol)];
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
    
    UICollectionViewLayoutAttributes *attr = [self findSectionAttributes:indexPath kind:elementKind];
    if(!attr){
        attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    
    //footer
    if (!isHeader) {
        y = [self getFooterY:attr];
        //需要同时处理上一个footer的位置
        if(section > 0){
            UICollectionViewLayoutAttributes *lastAttr = [self findSectionAttributes:[NSIndexPath indexPathForRow:0 inSection:section-1] kind:elementKind];
            CGFloat y = [self getFooterY:lastAttr];
            CGRect frame = lastAttr.frame;
            frame.origin.y = y;
            lastAttr.frame = frame;
        }
    }else{
        y = [self getHeaderY:attr];
        //需要同时处理上一个header的位置
        if(section > 0){
            UICollectionViewLayoutAttributes *lastAttr = [self findSectionAttributes:[NSIndexPath indexPathForRow:0 inSection:section-1] kind:elementKind];
            CGFloat y = [self getHeaderY:lastAttr];
            CGRect frame = lastAttr.frame;
            frame.origin.y = y;
            lastAttr.frame = frame;
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
    
    UICollectionViewLayoutAttributes *attr = [self findSectionAttributes:indexPath kind:elementKind];
    if(!attr){
        attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    }
    
    //footer
    if (!isHeader) {
        x = [self getFooterY:attr];
        //需要同时处理上一个footer的位置
        if(section > 0){
            UICollectionViewLayoutAttributes *lastAttr = [self findSectionAttributes:[NSIndexPath indexPathForRow:0 inSection:section-1] kind:elementKind];
            CGFloat x = [self getFooterX:lastAttr];
            CGRect frame = lastAttr.frame;
            frame.origin.x = x;
            lastAttr.frame = frame;
        }
    }else{
        x = [self getHeaderX:attr];
        //需要同时处理上一个header的位置
        if(section > 0){
            UICollectionViewLayoutAttributes *lastAttr = [self findSectionAttributes:[NSIndexPath indexPathForRow:0 inSection:section-1] kind:elementKind];
            CGFloat x = [self getHeaderX:lastAttr];
            CGRect frame = lastAttr.frame;
            frame.origin.x = x;
            lastAttr.frame = frame;
        }
    }

    attr.frame = CGRectMake(x, y, size.width, size.height);
    return attr;
}

//#pragma mark custom overrides updates
//-(void)finalizeCollectionViewUpdates{
//    [super finalizeCollectionViewUpdates];
//    self.deleteIndexPaths = nil;
//    self.insertIndexPaths = nil;
//}
//
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
//        UICollectionViewLayoutAttributes *attributesCopy = [attributes copy];
//        [self setActualSize:attributesCopy];
//        attributesCopy.alpha = 0.0;
//        attributesCopy.transform = CGAffineTransformMakeScale(.5, .5);
//        return attributesCopy;
//    }
//    [self setActualSize:attributes];
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

#pragma mark convinient

///autolayout 真值
-(void)setActualSize:(UICollectionViewLayoutAttributes *)attributes isInit:(BOOL)isInit{
    NSValue *value = [self.actualItemSizes objectForKey:attributes.indexPath];
    CGRect originFrame = attributes.frame;
    if(value){
        if(JH_IsScrollDirectionVertical){
            CGSize actualSize = [value CGSizeValue];
            CGFloat actualHeight = actualSize.height;
            if (actualHeight == originFrame.size.height) {
                return;
            }
            CGRect frame = attributes.frame;
            frame.size.height = actualHeight;
            attributes.frame = frame;
            //更新maxEnds
            if(!isInit){
                NSInteger section = attributes.indexPath.section;
                if(section < self.maxEnds.count){
                    NSMutableDictionary *sectionItemYs = self.maxEnds[section];
                    if(attributes.col != -1){
                        CGFloat colY = [[sectionItemYs objectForKey:@(attributes.col)] floatValue];
                        colY -= originFrame.size.height; //先减掉之前的值
                        colY += attributes.frame.size.height;
                        [sectionItemYs setObject:@(colY) forKey:@(attributes.col)];
                    }
                }
            }
        }else{
            CGSize actualSize = [value CGSizeValue];
            CGFloat actualWidth = actualSize.width;
            if (actualWidth == originFrame.size.width) {
                return;
            }
            CGRect frame = attributes.frame;
            frame.size.width = actualWidth;
            attributes.frame = frame;
            //更新maxEnds
            if(!isInit){
                NSInteger section = attributes.indexPath.section;
                if(section < self.maxEnds.count){
                    NSMutableDictionary *sectionItemXs = self.maxEnds[section];
                    if(attributes.col != -1){
                        CGFloat colX = [[sectionItemXs objectForKey:@(attributes.col)] floatValue];
                        colX -= originFrame.size.width; //先减掉之前的值
                        colX += attributes.frame.size.width;
                        [sectionItemXs setObject:@(colX) forKey:@(attributes.col)];
                    }
                }
            }
        }
    }
}

///footer位置
-(CGFloat)getFooterY:(UICollectionViewLayoutAttributes *)attr{
    NSInteger section = attr.indexPath.section;
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    //CGFloat y = [self getItemMaxYinSection:section] + insets.bottom;
    CGFloat y = [self getMaxYinSection:section withFooter:NO] + insets.bottom;
    return y;
}

-(CGFloat)getFooterX:(UICollectionViewLayoutAttributes *)attr{
    NSInteger section = attr.indexPath.section;
    UIEdgeInsets insets = [self jhListViewFlowLayoutInsetsAtSection:section];
    CGFloat x = [self getMaxXinSection:section withFooter:NO] + insets.right;
    return x;
}

///获取header位置
-(CGFloat)getHeaderY:(UICollectionViewLayoutAttributes *)attr{
    if(!attr) return 0;
    NSInteger section = attr.indexPath.section;
    CGFloat y = [self getMaxYinSection:section-1 withFooter:YES];
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat maxY = [self getMaxYinSection:section withFooter:YES];
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
    CGFloat x = [self getMaxXinSection:section-1 withFooter:YES];
    CGFloat offsetX = self.collectionView.contentOffset.x;
    CGFloat maxX = [self getMaxXinSection:section withFooter:YES];
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
    for (NSMutableArray *group in self.groupedAttributes) {
        for (UICollectionViewLayoutAttributes *attr in group) {
            if(attr.representedElementCategory == UICollectionElementCategoryCell && attr.indexPath.section == indexPath.section && attr.indexPath.row == indexPath.row){
                return attr;
            }
        }
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)findSectionAttributes:(NSIndexPath *)indexPath kind:(NSString *)kind{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section < self.headerAttributes.count){
            return self.headerAttributes[indexPath.section];
        }
    }else{
        if(indexPath.section < self.footerAttributes.count){
            return self.footerAttributes[indexPath.section];
        }
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)findDecorationAttributes:(NSIndexPath *)indexPath {
    if(indexPath.section < self.decorationAttributes.count){
        return self.decorationAttributes[indexPath.section];
    }
    return nil;
}

- (CGFloat)getMaxYinSection:(NSInteger)section withFooter:(BOOL)withFooter{
    NSInteger maxCount = self.groupedAttributes.count;
    if(maxCount == 0){
        return 0;
    }else if(section >= maxCount){
        section = maxCount - 1;
    }else if(section < 0){
        section = 0;
        return [self getMinYinSection:section];
    }
    NSMutableArray *group = self.groupedAttributes[section];
    CGFloat maxY = 0;
    if(group.count == 0){
        return [self getMaxYinSection:section - 1 withFooter:YES];
    }
    for (UICollectionViewLayoutAttributes *attributes in group) {
        if (withFooter) {
            CGFloat tempY = CGRectGetMaxY(attributes.frame);
            if(tempY > maxY){
                maxY = tempY;
            }
        }else{
            if(attributes.representedElementKind != UICollectionElementKindSectionFooter && attributes.representedElementCategory != UICollectionElementCategoryDecorationView ){
                CGFloat tempY = CGRectGetMaxY(attributes.frame);
                if(tempY > maxY){
                    maxY = tempY;
                }
            }
        }
    }
    return maxY;
}

- (CGFloat)getMinYinSection:(NSInteger)section{
    NSInteger maxCount = self.groupedAttributes.count;
    if(maxCount == 0){
        return 0;
    }else if(section >= maxCount){
        section = maxCount - 1;
        return [self getMaxYinSection:section withFooter:YES];
    }else if(section <= 0){
        return 0;
    }
    NSMutableArray *group = self.groupedAttributes[section];
    CGFloat minY = 0;
    if (group.count > 0) {
        UICollectionViewLayoutAttributes *attr = group.firstObject;
        minY = CGRectGetMinY(attr.frame);
    }else{
        return [self getMaxYinSection:section - 1 withFooter:YES];
    }
    return minY;
}

- (CGFloat)getMaxXinSection:(NSInteger)section withFooter:(BOOL)withFooter{
    NSInteger maxCount = self.groupedAttributes.count;
    if(maxCount == 0){
        return 0;
    }else if(section >= maxCount){
        section = maxCount - 1;
    }else if(section < 0){
        section = 0;
        return [self getMinXinSection:section];
    }
    NSMutableArray *group = self.groupedAttributes[section];
    CGFloat maxX = 0;
    if(group.count == 0){
        return [self getMaxXinSection:section - 1 withFooter:YES];
    }
    for (UICollectionViewLayoutAttributes *attributes in group) {
        if (withFooter) {
            CGFloat tempX = CGRectGetMaxX(attributes.frame);
            if(tempX > maxX){
                maxX = tempX;
            }
        }else{
            if(attributes.representedElementKind != UICollectionElementKindSectionFooter && attributes.representedElementCategory != UICollectionElementCategoryDecorationView ){
                CGFloat tempX = CGRectGetMaxX(attributes.frame);
                if(tempX > maxX){
                    maxX = tempX;
                }
            }
        }
    }
    return maxX;
}

- (CGFloat)getMinXinSection:(NSInteger)section{
    NSInteger maxCount = self.groupedAttributes.count;
    if(maxCount == 0){
        return 0;
    }else if(section >= maxCount){
        section = maxCount - 1;
        return [self getMaxXinSection:section withFooter:YES];
    }else if(section <= 0){
        return 0;
    }
    NSMutableArray *group = self.groupedAttributes[section];
    CGFloat minX = 0;
    if (group.count > 0) {
        UICollectionViewLayoutAttributes *attr = group.firstObject;
        minX = CGRectGetMinX(attr.frame);
    }else{
        return [self getMaxXinSection:section - 1 withFooter:YES];
    }
    return minX;
}

/// 返回contentHeight
- (CGFloat)contentHeight{
    if (JH_IsScrollDirectionVertical) {
        NSInteger lastSection = self.groupedAttributes.count - 1;
        _contentHeight = [self getMaxYinSection:lastSection withFooter:YES];
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
        NSInteger lastSection = self.groupedAttributes.count - 1;
        _contentWidth = [self getMaxXinSection:lastSection withFooter:YES];
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

#pragma mark public

-(void)setActualCellSize:(CGSize)size atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath){
        [self.actualItemSizes setObject:[NSValue valueWithCGSize:size] forKey:indexPath];
    }
}

#pragma mark delegate

- (NSInteger)jhListViewFlowLayoutColumnsAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:columnsAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self columnsAtSection:section];
    }
    return 1;
}

- (CGSize)jhListViewFlowLayoutHeaderSizeAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:headerSizeAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self headerSizeAtSection:section];
    }
    return CGSizeZero;
}

- (CGSize)jhListViewFlowLayoutFooterSizeAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:footerSizeAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self footerSizeAtSection:section];
    }
    return CGSizeZero;
}

- (CGSize)jhListViewFlowLayoutItemSizeForIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:itemSizeForIndexPath:)]){
        return [self.delegate jh_listView:self.collectionView layout:self itemSizeForIndexPath:indexPath];
    }
    return CGSizeZero;
}

- (UIEdgeInsets)jhListViewFlowLayoutInsetsAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:insetsAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self insetsAtSection:section];
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)jhListViewFlowLayoutLineSpacingAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:lineSpacingAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self lineSpacingAtSection:section];
    }
    return 0;
}

- (CGFloat)jhListViewFlowLayoutItemSpacingAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:itemSpacingAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self itemSpacingAtSection:section];
    }
    return 0;
}

- (BOOL)jhListViewFlowLayoutHeaderPinToTopAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:headerPinToTopAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self headerPinToTopAtSection:section];
    }
    return 0;
}

- (NSString *)jhListViewFlowLayoutDecorationViewClassAtSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jh_listView:layout:decorationViewClassAtSection:)]){
        return [self.delegate jh_listView:self.collectionView layout:self decorationViewClassAtSection:section];
    }
    return nil;
}
@end
