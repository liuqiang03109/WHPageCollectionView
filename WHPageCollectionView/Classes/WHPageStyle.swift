//
//  WHPageStyle.swift
//  滑动视图
//
//  Created by DanLi on 2016/12/5.
//  Copyright © 2016年 DanLi. All rights reserved.
//

import UIKit

public class WHPageStyle{
    
    public init() {
        
    }
    
    ///头视图的高度
    public var titileViewHeight: CGFloat = 44
    
    ///头视图标签的非选中颜色
    public var normalColor: UIColor = .black
    
    ///头视图标签的选中颜色
    public var selectColor = UIColor.orange
    
    ///头视图标签的文字大小
    public var titleFont: CGFloat = 13
    
    ///头视图标签选中文字
    public var selectFont: CGFloat = 16
    
    
    ///头视图是否可以滚动
    public var isScrollEnable: Bool = false
    
    ///头视图标签间距
    public var titleMargin: CGFloat = 20
    
    ///是否显示底部线条
    public var isShowBottomLine: Bool = false
    
    ///底部线条的颜色
    public var bottomLineColor: UIColor = UIColor.orange
    
    ///底部线条的高度
    public var bottomLineHeight: CGFloat = 2
    
}
