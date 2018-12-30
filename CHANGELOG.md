# Change Log

# 1.3 (2018-12-31)

- Added support for Swift 4.2.

# 1.2 (2017-09-27)

- `animateTableView()` and `animateCells()` have been renamed to `animate()` and are differentiated based on the parameter passed in.

- Adding a completion handler when `reloadData(inPlace: animated:)` is called synchronously.

- `reloadData(smoothly: animated:)` has been renamed `reloadData(inPlace: animated:)`

- A fix for `animateWithFade()` potentially calling it's completion block multiple times.

# 1.1 (2017-08-27)

This release updates behavior that cell animations will fire their completion block after all the cell animations have completed, not after each individual animation.

It is not a minor semantic version bump because while it is a bug fix, it produces a change in behavior which some people may have been relying on.


# 1.0.1 (2017-08-27)

This update adds an `indexPaths` parameter to `func animateCells`. 

~`func animateCells(animation: TableViewAnimation.Cell, completion: (() -> Void)? = nil)`~

`func animateCells(animation: TableViewAnimation.Cell, indexPaths: [IndexPath]? = nil, completion: (() -> Void)? = nil)`

This change is non-breaking, since `indexPaths` parameter is optional. Your old code should continue to work as it did before.



# 1.0 (2016-11-15)

Initial release.
