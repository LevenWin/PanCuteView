# PanCuteView
模仿QQ消息可滑动已读的小气泡
#### 感谢
基于[KittenYange](http://kittenyang.com/drawablebubble/)的方案进行优化


#### 动态图
![](https://github.com/LevenWin/PanCuteView/blob/master/screen.gif)

### 方法
```
    _cuteView = [BXLMessageNoticeView new];
    _cuteView.countString = @"13";
    _cuteView.delegate = self;
    [self.view addSubview:_cuteView];
```

### 代理

```
@protocol BXLPanCuteViewDelegate <NSObject>

- (void)BXLPanCuteViewDidGestureToDismiss;

@end

```

欢迎star！
