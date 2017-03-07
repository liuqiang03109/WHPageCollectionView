//
//  WHTitleView.swift
//  滑动视图
//
//  Created by DanLi on 2016/12/5.
//  Copyright © 2016年 DanLi. All rights reserved.
//

import UIKit

protocol WHTitleViewDelegate: class {
    
    func titleView(_ titleView: WHTitleView, targetIndex: Int);

}


class WHTitleView: UIView {
    
    weak var delegate: WHTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: WHPageStyle
    fileprivate var currentIndex = 0
    fileprivate weak var sourceLabel = UILabel()
    
    
    
    fileprivate lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    fileprivate lazy var bottomLine: UIView = {
       let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
    }()
    
    
    fileprivate var titleLabels = [UILabel]()
    
    
    
    init(frame: CGRect, titles: [String], style: WHPageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("需要实现init?(coder aDecoder: NSCoder)方法")
    }
    
    
    
    

}

// MARK - 设置UI界面
extension WHTitleView {
    fileprivate func setupUI() {
        
        addSubview(scrollView)
        if style.isShowBottomLine {
            addSubview(bottomLine)
        }
        addTitleLabels()
        caculateTitleLabelsFrame()
    }
    
    private func addTitleLabels() {
        
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textColor = style.normalColor
            label.font = UIFont.systemFont(ofSize: style.titleFont)
            label.textAlignment = .center
            label.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick))
            label.addGestureRecognizer(tap)
            label.isUserInteractionEnabled = true
            scrollView.addSubview(label)
            
            titleLabels.append(label)
            
        }
    }

    private func caculateTitleLabelsFrame() {
        let count = CGFloat(titles.count)
        
        var width: CGFloat = UIScreen.main.bounds.width / count
        let height: CGFloat = bounds.height
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        for (i, label) in titleLabels.enumerated() {
            
            if style.isScrollEnable {
                width = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: style.selectFont)], context: nil).width
                if i == 0 {
                    x = style.titleMargin * 0.5
                } else {
                    x = titleLabels[i - 1].frame.maxX + style.titleMargin
                }
            } else {
                if i != 0{
                    x = titleLabels[i - 1].frame.maxX
                }
            }
            if i == 0 && style.isShowBottomLine {
                label.textColor = style.selectColor
                label.font = UIFont.systemFont(ofSize: style.selectFont)
                bottomLine.frame.origin.x = x
                bottomLine.frame.size.width = width
            } else if i == 0 {
                label.textColor = style.selectColor
                label.font = UIFont.systemFont(ofSize: style.selectFont)
            }
            label.frame = CGRect(x: x, y: y, width: width, height: height)
            
        }
        let scrollContentWidth = style.isScrollEnable ? titleLabels[Int(count - 1)].frame.maxX + style.titleMargin * 0.5 : titleLabels[Int(count - 1)].frame.maxX
        scrollView.contentSize = CGSize(width: scrollContentWidth, height: 0)
        
    }
    
    
}

// MARK - 事件处理
extension WHTitleView {
    
    @objc fileprivate func titleLabelClick(tap: UITapGestureRecognizer) {
        
        
        delegate?.titleView(self, targetIndex: tap.view!.tag)
        
        scrollTitleLabel(index: tap.view!.tag)
        
    }
    
    func scrollTitleLabel(index: Int) {
        if index == currentIndex {
            return
        }
        let newLabel = titleLabels[index]
        sourceLabel = newLabel
        let oldLabel = titleLabels[currentIndex]
        
        oldLabel.textColor = style.normalColor
        newLabel.textColor = style.selectColor
        
        oldLabel.font = UIFont.systemFont(ofSize: style.titleFont)
        newLabel.font = UIFont.systemFont(ofSize: style.selectFont)
        
        let centerX = newLabel.center.x
        var offSetX = centerX - scrollView.frame.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        if offSetX > scrollView.contentSize.width - scrollView.frame.width {
            offSetX = scrollView.contentSize.width - scrollView.frame.width
        }
        
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomLine.frame.origin.x = newLabel.frame.origin.x - offSetX
                self.bottomLine.frame.size.width = newLabel.frame.width
            })
        }
        currentIndex = index
    }
    
}

// MARK - WHContentView代理方法
extension WHTitleView: WHContentViewDelegate {
    func contentView(_ contentView: WHContentView, targetIndex: Int) {
        scrollTitleLabel(index: targetIndex)
    }
    
    func contentView(_ contentView: WHContentView, targetIndex: Int, progress: CGFloat) {
        let newLabel = titleLabels[targetIndex]
        let oldLabel = titleLabels[currentIndex]
        let rateFont = style.selectFont - style.titleFont
        newLabel.font = UIFont.systemFont(ofSize: style.titleFont + rateFont * progress)
        oldLabel.font = UIFont.systemFont(ofSize: style.selectFont - rateFont * progress)
        
        let centerX = oldLabel.center.x
        
        var offSetX = centerX - scrollView.frame.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        if offSetX > scrollView.contentSize.width - scrollView.frame.width {
            offSetX = scrollView.contentSize.width - scrollView.frame.width
        }
        
        if style.isShowBottomLine {
            let rateW = newLabel.frame.width - oldLabel.frame.width
            let rateX = newLabel.frame.origin.x - oldLabel.frame.origin.x
            bottomLine.frame.origin.x = oldLabel.frame.origin.x - offSetX + rateX * progress
            bottomLine.frame.size.width = oldLabel.frame.width + rateW * progress
        }
        
    }
    
}









