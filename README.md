# AraSegmentedView

[![Version](https://img.shields.io/cocoapods/v/AraSegmentedView.svg?style=flat)](https://cocoapods.org/pods/AraSegmentedView)
[![License](https://img.shields.io/cocoapods/l/AraSegmentedView.svg?style=flat)](https://cocoapods.org/pods/AraSegmentedView)
[![Platform](https://img.shields.io/cocoapods/p/AraSegmentedView.svg?style=flat)](https://cocoapods.org/pods/AraSegmentedView)

AraSegmentedView 是模仿 `哔哩哔哩` iOS 客户端的分类切换滚动视图。

AraSegmentedView 将 控制器（AraSegmentedControl） 与 滚动视图（AraSegmentedView） 分离，用户可自己定制两者所在位置。

##效果预览

<div>
	<img src="https://raw.githubusercontent.com/Arabaku/AraSegmentedView/master/Assets/style1.gif" width = "30%" div/>
    <img src="https://raw.githubusercontent.com/Arabaku/AraSegmentedView/master/Assets/style2.gif" width = "30%" div/>
</div>

## Requirements

- iOS 10.0+
- Swift 5.0

## Installation

### CocoaPods

在项目的 Podfile 中加入
```ruby
pod 'AraSegmentedView'
```
更新本地仓库
```
pod repo update
```
安装
```
pod intall
```

### 手动导入

把 `Source` 文件夹拷贝至你的项目。

## Usage

1、初始化 AraSegmentedControl
```swift
let segmentedControl = AraSegmentedControl(
    frame: CGRect(x: 0, y: 0, width: 250, height: 40),
    titlesArray: ["热点","好友动态","视频","搞笑","NBA","同城资讯"],
    initIndex: 1
)
segmentedControl.titleNormalColor = UIColor.white.withAlphaComponent(0.5)
segmentedControl.titleSelectedColor = UIColor.white
segmentedControl.titleFont = UIFont.systemFont(ofSize: 15)
segmentedControl.lineViewMarginBottom = 3
segmentedControl.buttonMarginMin = 15
segmentedControl.tabViewAlign = .average
```

2、初始化 AraSegmentedView
```swift
let segmentedView = AraSegmentedView(
    frame: CGRect(x: 0, y: topHeight(), width: self.view.bounds.width, height: self.view.bounds.height - topHeight() - bottomHeight()),
    segmentedControl: segmentedControl,
    childVCsArray: [ChildViewController1(), ChildViewController2(), ChildViewController3(), ChildViewController4(), ChildViewController5(), ChildViewController6()]
)
```

3、代理（可选）
```swift
segmentedView.delegate = self

func araSegmentedView(_ araSegmentedView: AraSegmentedView, didClickIndex index: Int, oldIndex: Int) {
    print("点击了index：\(index)，上一个index：\(oldIndex)")
}

func araSegmentedView(_ araSegmentedView: AraSegmentedView, didMoveToIndex index: Int) {
    print("已经移动到：\(index)")
}

func araSegmentedView(_ araSegmentedView: AraSegmentedView, isDraggingFromIndex fromIndex: Int, toIndex: Int, progress: Float) {
    print("从：\(fromIndex), 拖动到：\(toIndex), 进度：\(progress)")
}

func araSegmentedViewIsMoving(_ araSegmentedView: AraSegmentedView) {
    
}
```

### AraSegmentedControl 属性说明

属性 | 说明 | 默认值
:-:|:-:|:-:
titleFont | title 字体 | UIFont.systemFont(ofSize: 14) |
titleNormalColor | title 默认状态下文字颜色 | UIColor.white.withAlphaComponent(0.5) |
titleSelectedColor | title 选中状态下文字颜色 | UIColor.white |
titleMarginMin | title 间隙允许的最小值 | 15 |
showLineView | 是否显示下划线 | true |
lineViewHeight | 下划线高度 | 2 |
lineViewMarginBottom | 下划线距离容器底部高度 | 3 |
tabViewAlign | 排版方式：平均/自左向右<br/>.average时，如果 content.width > AraSegmentedControl.width，进行.left排版 | .average |

## Author

Arabaku, Arabaku@126.com

## License

AraSegmentedView is available under the MIT license. See the LICENSE file for more info.
