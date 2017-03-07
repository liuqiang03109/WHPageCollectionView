//
//  ViewController.swift
//  WHPageCollectionView
//
//  Created by wenhe-liu on 02/23/2017.
//  Copyright (c) 2017 wenhe-liu. All rights reserved.
//

import UIKit
import WHPageCollectionView


private let cellID = "cellID"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置自定义表情/键盘布局
        let layout = WHPageCollectionViewLayout()
        //设置布局属性
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        //设置title标题格式
        let style = WHPageStyle()
        style.isShowBottomLine = true
        
        //设置pageCollectionView的位置
        let frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 300)
        let page = WHPageCollectionView(frame: frame, titles: ["表情", "专属", "热门", "美女"], layout: layout, style: style, isTitleInTop: true)
        //设置数据源
        page.dataSource = self
        view.addSubview(page)
        //注册cell
        page.register(cellClass: UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        
        
    }
 

}



extension ViewController: WHPageCollectionViewDataSource {
    
    func numberOfSections(in whPageCollectionView: WHPageCollectionView) -> Int {
        return 4
    }
    func whPageCollectionView(_ whPageCollectionView: WHPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section * 9 + 1
    }
    func whPageCollectionView(_ whPageCollectionView: WHPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1)
        
        return cell
    }
    
}

