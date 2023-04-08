//
//  JHListViewCompositionalLayout.swift
//  JHUIKit
//
//  Created by Junqing Hao on 2022/6/15.
//

import UIKit

@available(iOS 13.0, *)
public enum SectionType {
    case list,waterFall(Int),nested
}

@available(iOS 13.0, *)
public protocol JHListViewCompositionalDelegateLayout : NSObjectProtocol{
    
    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, columnsAtSection: NSInteger) -> NSInteger
    
    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, lineSpacingAtSection: NSInteger) -> NSInteger
    
    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, itemSpacingAtSection: NSInteger) -> NSInteger
    
    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, insetsAtSection: NSInteger) -> UIEdgeInsets
    
    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, headerSizeAtSection: NSInteger) -> CGSize
    
    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, footerSizeAtSection: NSInteger) -> CGSize

    func jh_listView(_ collectionView: UICollectionView?, layout collectionViewLayout: UICollectionViewCompositionalLayout, section: NSInteger) -> SectionType
}

@available(iOS 13.0, *)
    public typealias SectionProvider = (NSInteger,NSCollectionLayoutEnvironment)->NSCollectionLayoutSection

//public typealias GroupProvider = (NSInteger,NSCollectionLayoutEnvironment)->NSCollectionLayoutSection
//public typealias ItemProvider = (NSInteger,NSCollectionLayoutEnvironment)->NSCollectionLayoutSection


@available(iOS 13.0, *)
@objcMembers open class JHListViewCompositionalLayout : NSObject{
    public var delegate : JHListViewCompositionalDelegateLayout?
    //public lazy var layout : UICollectionViewCompositionalLayout = composionLayout()
    public var maxEnds = [[Int:Float]]()
    public var actualItemSizes : [NSIndexPath : CGSize] = [:]
//    public var sectionProvider : SectionProvider = {
//        (section,evironment) in
//        return NSCollectionLayoutSection.init(group: nil)
//    }
    
//    func composionLayout()->UICollectionViewCompositionalLayout{
//        let _compLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, environment in
//            self.sectionProvider(section, environment)
//        }, configuration: self.layoutConfiguration())
//        return _compLayout
//    }
    
    ///sectionProvider 返回某一个section的内容
//    func sectionProvider(_ section:NSInteger,_ environment:NSCollectionLayoutEnvironment)->NSCollectionLayoutSection?{
//        let a = self.layout.collectionView?.numberOfItems(inSection: section)
//
//        guard let items = self.layout.collectionView?.numberOfItems(inSection: section)else {
//            return nil
//        }
//
//        var itemYs = [Int:Float]()
//        var columns = 2
//
//        columns = 2
//
//        let itemWidth = 214.0
//
//
////        let itemSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.absolute(itemWidth) , heightDimension: .estimated(50))
//
//        var groupSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.estimated(200))
//
//        let group:NSCollectionLayoutGroup = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment in
//            var groupItems = [NSCollectionLayoutGroupCustomItem]()
//            for item in 0..<items {
//                var minY = itemYs[0] ?? 0
//                var minCol = 0
//                for col in 0..<columns {
//                    if(item == 0){
//                        itemYs[col] = 0
//                    }else{
//                        let colY = itemYs[col] ?? 0
//                        if colY < minY{
//                            minY = colY
//                            minCol = col
//                        }
//                    }
//                }
//                let x = itemWidth * Double(minCol)
//              let y = minY
//                let height = arc4random()%50 + 50
//                let item :NSCollectionLayoutGroupCustomItem = NSCollectionLayoutGroupCustomItem(frame: CGRect(x: x, y: Double(y), width: itemWidth, height: Double(height)), zIndex: 0)
//
//
//                itemYs[minCol] = minY + Float(height)
//
//                groupItems.append(item)
//            }
//            return groupItems
//        }
//
//        let sectionItem = NSCollectionLayoutSection(group: group)
//
//        return sectionItem
//
//    }
//
    ///config
    func layoutConfiguration()->UICollectionViewCompositionalLayoutConfiguration{
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        config.interSectionSpacing = 30;
        return config
    }
}

@available(iOS 13.0, *)
extension JHListViewCompositionalLayout{
    //-(void)setActualCellSize:(CGSize)size atIndexPath:(NSIndexPath *)indexPath;
    
    func setActualCellSize(size:CGSize,atIndexPath indexPath:NSIndexPath){
        
    }
}

