//
//  JHBaseViewModel.m
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/5.
//

#import "JHBaseViewModel.h"

@implementation JHBaseViewModel

-(BOOL)requestData{
    if(self.url.length <= 0){
        return 0;
    }
    return 1;
}

-(void)parseData:(id)rawData{
//    if (self.complete) {
//        self.complete(YES, self.datas);
//    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

@end
