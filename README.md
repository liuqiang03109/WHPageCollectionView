# WHPageCollectionView

[![CI Status](http://img.shields.io/travis/wenhe-liu/WHPageCollectionView.svg?style=flat)](https://travis-ci.org/wenhe-liu/WHPageCollectionView)
[![Version](https://img.shields.io/cocoapods/v/WHPageCollectionView.svg?style=flat)](http://cocoapods.org/pods/WHPageCollectionView)
[![License](https://img.shields.io/cocoapods/l/WHPageCollectionView.svg?style=flat)](http://cocoapods.org/pods/WHPageCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/WHPageCollectionView.svg?style=flat)](http://cocoapods.org/pods/WHPageCollectionView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WHPageCollectionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WHPageCollectionView"
```
```swift
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


```


## Author

wenhe-liu, liu.wen.he@chrjdt.com

## License

WHPageCollectionView is available under the MIT license. See the LICENSE file for more info.
