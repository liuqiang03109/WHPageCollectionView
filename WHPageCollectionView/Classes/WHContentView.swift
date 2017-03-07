//
//  WHContentView.swift
//  滑动视图
//
//  Created by DanLi on 2016/12/5.
//  Copyright © 2016年 DanLi. All rights reserved.
//

import UIKit

let kID = "kID"

protocol WHContentViewDelegate: class {
    func contentView(_ contentView: WHContentView, targetIndex: Int)
    
    func contentView(_ contentView: WHContentView, targetIndex: Int, progress: CGFloat)
    
}



class WHContentView: UIView {

    weak var delegate: WHContentViewDelegate?
    
    fileprivate var contentVcs: [UIViewController]
    fileprivate var parentVC: UIViewController
    

    fileprivate var startOffX: CGFloat = 0
    fileprivate var isForbid: Bool = false
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = false
        collectionView.bounces = false
        return collectionView
    }()
    
    init(frame: CGRect, contentVcs: [UIViewController], parentVc: UIViewController) {
        self.contentVcs = contentVcs
        self.parentVC = parentVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}

// MARK - 设置UI界面
extension WHContentView {
    fileprivate func setupUI() {
        addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kID) 
    }
    
    
}

// MARK - collectionView数据源方法
extension WHContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kID, for: indexPath)
        
        cell.contentView.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)), alpha: 1)
        return cell
    }
}

// MARK - collectionView代理方法
extension WHContentView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        notiyTitleViewChange()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            notiyTitleViewChange()
        }
    }
    
    
    
    
    
    private func notiyTitleViewChange() {
        
        guard !isForbid else { return }
//        if collectionView.contentOffset.x / collectionView.frame.width > lastIndex {
//            lastIndex = collectionView.contentOffset.x / collectionView.frame.width
//        } else if collectionView.contentOffset.x / collectionView.frame.width < lastIndex {
//            lastIndex = collectionView.contentOffset.x / collectionView.frame.width
//        }
//        if lastIndex < 0 {
//            lastIndex = 0
//        }
//        if lastIndex > CGFloat(contentVcs.count) - 1.0 {
//            lastIndex = CGFloat(contentVcs.count) - 1.0
//        }
        
        delegate?.contentView(self, targetIndex: Int(collectionView.contentOffset.x / collectionView.frame.width))
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbid = true
        startOffX = collectionView.contentOffset.x
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard startOffX != scrollView.contentOffset.x else {
            return
        }
        var lastIndex = 0
        var progress: CGFloat = 0
        let currentIndex = Int(startOffX / scrollView.bounds.width)
        if startOffX < collectionView.contentOffset.x {//向右
            lastIndex = currentIndex + 1
            if lastIndex > contentVcs.count - 1 {
                lastIndex = contentVcs.count - 1
            }
            progress = (collectionView.contentOffset.x - startOffX) / collectionView.frame.width
        } else {//向左滑
            lastIndex = currentIndex - 1
            if lastIndex < 0 {
                lastIndex = 0
            }
            progress = (startOffX - collectionView.contentOffset.x) / collectionView.frame.width
        }
//        print(progress)
        delegate?.contentView(self, targetIndex: lastIndex, progress: progress)
//        delegate?.contentView(self, targetIndex: Int(collectionView.contentOffset.x / collectionView.frame.width))
        
    }
    
    
    
    
    
}




// MARK - WHTitleView代理
extension WHContentView: WHTitleViewDelegate {
    func titleView(_ titleView: WHTitleView, targetIndex: Int) {
        let point = CGPoint(x: CGFloat(targetIndex) * collectionView.bounds.width, y: 0)
        collectionView.setContentOffset(point, animated: false)
    }
}







