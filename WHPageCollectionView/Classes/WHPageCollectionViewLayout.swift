//
//  WHPageCollectionViewLayout.swift
//  WHPageCollectionView
//
//  Created by DanLi on 2016/12/12.
//  Copyright © 2016年 DanLi. All rights reserved.
//

import UIKit

public class WHPageCollectionViewLayout: UICollectionViewFlowLayout {
///   列数
    internal var cols: Int
///   行数
    internal var rows: Int
//    最大宽度
    fileprivate var maxW: CGFloat = 0
    
    
    fileprivate var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    public init(_ cols: Int = 4, _ rows: Int = 2) {
        self.cols = cols
        self.rows = rows
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func prepare() {
        let itemW = ((collectionView!.bounds.width) - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        let sections = collectionView!.numberOfSections
        var proPageCount = 0
        for i in 0..<sections {
            let items = collectionView!.numberOfItems(inSection: i)
            for j in 0..<items {
                let indexPath = IndexPath(item: j, section: i)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let page = j / (cols * rows)
                let index = j % (cols * rows)
                
                let itemY = sectionInset.top + CGFloat(index / cols) * (itemH + minimumLineSpacing)
                let itemX = sectionInset.left + CGFloat(proPageCount + page) * collectionView!.bounds.width + CGFloat(index % cols) * (minimumInteritemSpacing + itemW)
                
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                layoutAttributes.append(attr)
            }
            proPageCount += ((items - 1) / (cols * rows) + 1)
        }
        maxW = CGFloat(proPageCount) * collectionView!.bounds.width
    }
    
}

// MARK - 返回cell位置
extension WHPageCollectionViewLayout {
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
}

// MARK - 返回内容大小
extension WHPageCollectionViewLayout {
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: maxW, height: 0)
    }
}









