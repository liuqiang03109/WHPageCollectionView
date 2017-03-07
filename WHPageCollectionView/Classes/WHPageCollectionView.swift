//
//  WHPageCollectionView.swift
//  WHPageCollectionView
//
//  Created by DanLi on 2016/12/12.
//  Copyright © 2016年 DanLi. All rights reserved.
//

import UIKit
//import AVFoundation


private let pageHeight: CGFloat = 20

public protocol WHPageCollectionViewDataSource: class {
    func numberOfSections(in whPageCollectionView: WHPageCollectionView) -> Int
    func whPageCollectionView(_ whPageCollectionView: WHPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func whPageCollectionView(_ whPageCollectionView: WHPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
}



public class WHPageCollectionView: UIView {

    public weak var dataSource: WHPageCollectionViewDataSource?
    
    
    
    fileprivate var titles: [String]
    fileprivate var style: WHPageStyle
    fileprivate var layout: WHPageCollectionViewLayout
    fileprivate var isTitleInTop: Bool
    fileprivate var titleView: WHTitleView!

    fileprivate var proSection = 0
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionY = self.isTitleInTop ? self.style.titileViewHeight : 0
        let frame = CGRect(x: 0, y: collectionY, width: self.bounds.width, height: self.bounds.height - self.style.titileViewHeight - pageHeight)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    fileprivate lazy var pageControl: UIPageControl = {
        let collectionY = self.collectionView.frame.maxY
        let frame = CGRect(x: 0, y: collectionY, width: self.bounds.width, height: pageHeight)
        let pageControl = UIPageControl(frame: frame)
        pageControl.backgroundColor = .red
        return pageControl
    }()
    
    public func getWHPageCollectionView(frame: CGRect, titles: [String], layout: WHPageCollectionViewLayout, style: WHPageStyle, isTitleInTop: Bool, dataSource: WHPageCollectionViewDataSource) -> (WHPageCollectionView){
        let pageView = WHPageCollectionView(frame: frame, titles: titles, layout: layout, style: style, isTitleInTop: isTitleInTop)
        
        pageView.dataSource = dataSource
        
        return pageView
    }
    
    public init(frame: CGRect, titles: [String], layout: WHPageCollectionViewLayout, style: WHPageStyle, isTitleInTop: Bool) {
        self.titles = titles
        self.layout = layout
        self.style = style
        self.isTitleInTop = isTitleInTop
        super.init(frame: frame)
        setupUI()
        
//        let url = URL(string: "http://baidu.com")
//        
//        let asset = AVURLAsset(url: url!)
//        
//        asset.resourceLoader.setDelegate(<#T##delegate: AVAssetResourceLoaderDelegate?##AVAssetResourceLoaderDelegate?#>, queue: <#T##DispatchQueue?#>)
//        
//        let item = AVPlayerItem(asset: asset)
//        
//        let layer = AVPlayer(playerItem: item)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
// MARK - 对外暴露的方法
extension WHPageCollectionView {
    
    public func register(cellClass: AnyClass?, forCellWithReuseIdentifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    public func register(nib: UINib?, forCellWithReuseIdentifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    
}


// MARK - 设置UI界面
extension WHPageCollectionView {
    fileprivate func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)
        setupTitleView()
    }
    
    private func setupTitleView() {
        let titleViewY = isTitleInTop ? 0 : bounds.height - style.titileViewHeight
        let frame = CGRect(x: 0, y: titleViewY, width: bounds.width, height: style.titileViewHeight)
        titleView = WHTitleView(frame: frame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
    }
    
    
}

// MARK - collectionView 数据源方法
extension WHPageCollectionView : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = dataSource?.whPageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (items - 1) / (layout.cols * layout.rows) + 1
        }
        return items
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.whPageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
    
}

// MARK - collectionView代理方法
extension WHPageCollectionView: UICollectionViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustTitleViewPosition()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            adjustTitleViewPosition()
        }
    }
    
    private func adjustTitleViewPosition() {
        
        let offX = collectionView.contentOffset.x
//        通过collectionViewCell上的一个点  得到当前cell所在的indexPath
        
        guard let targetPath = collectionView.indexPathForItem(at: CGPoint(x: offX + layout.sectionInset.left + 1, y: layout.sectionInset.top + 1)) else {
            return
        }
        
//        print(targetPath.section)
        if proSection != targetPath.section {
            titleView.scrollTitleLabel(index: targetPath.section)
            pageControl.numberOfPages = ((dataSource?.whPageCollectionView(self, numberOfItemsInSection: targetPath.section) ?? 0) + 1) / (layout.cols * layout.rows) + 1
            proSection = targetPath.section
        }
        pageControl.currentPage = targetPath.item / (layout.cols * layout.rows)
    }
}

extension WHPageCollectionView: WHTitleViewDelegate {
    func titleView(_ titleView: WHTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.contentOffset.x -= layout.sectionInset.left
        let items = (dataSource?.whPageCollectionView(self, numberOfItemsInSection: targetIndex) ?? 0) + 1
        pageControl.numberOfPages = (items) / (layout.cols * layout.rows) + 1
//        collectionView.setContentOffset(CGPoint(x:collectionView.bounds.width * CGFloat(targetIndex) ,y: 0), animated: false)
        proSection = targetIndex
        pageControl.currentPage = 0
    }
}










