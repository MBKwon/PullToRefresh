**Attention:** As of iOS 6.0, there is a [UIRefreshControl](https://developer.apple.com/library/ios/documentation/uikit/reference/UIRefreshControl_class/Reference/Reference.html) object that makes adding pull-to-refresh functionality super easy. If you only need to support iOS 6.0 and later, I'd recommend using [UIRefreshControl](https://developer.apple.com/library/ios/documentation/uikit/reference/UIRefreshControl_class/Reference/Reference.html) instead.

### PullToRefresh

A simple iPhone TableViewController for adding pull-to-refresh functionality.

![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-1.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-2.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-3.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-4.png)

Inspired by [leah](https://github.com/leah) and her project [leah / PullToRefresh](https://github.com/leah/PullToRefresh).


How to install

1. Copy the files, [PullRefreshTableView.h](https://github.com/MBKwon/PullToRefresh/tree/master/Classes/PullRefreshTableView.h),
[PullRefreshTableView.m](https://github.com/MBKwon/PullToRefresh/tree/master/Classes/PullRefreshTableView.m),
and [arrow.png](https://github.com/MBKwon/PullToRefresh/blob/master/arrow.png) into your project.

2. Link against the QuartzCore framework (used for rotating the arrow image).

3. Create a UITableView that is a subclass of PullRefreshTableView in your ViewController where you want to use Pull-to-refresh.

4. Customize by delegate your own refresh() method.


Enjoy!