# Tableau


### Animations are cool. UITableView isn't. So why not make animating UITableView cool?

---

##### The entire API for Tableau consists of an animation, and a call to animate. It's as simple as that.

##### Tableau takes the annoying nature of reloading UITableViews and minimizes the API to just thinking of how to transform 1 UITableViewcell.

### In practice, all you'll have to do is this.

```swift
self.tableView.reloadData()
self.tableView.animateRows(animation: myCoolAnimation)
```

Animations are completely customizable and configurable. Tableau provides a few built-in defaults that work nicely out the box, if you don't want to make your own.

## Let's look at some examples.


### Animating from the left with a nice stagger:

```swift
TableViewAnimation.left(duration: 0.5, staggered: true)
```

![](images/Animations/left.gif)


### Pushing from the top can make a nice initial loading effect:

```swift
TableViewAnimation.top(duration: 0.5)
```

![](images/Animations/top.gif)

### Or try a simple fade for elegance's sake:

```swift
TableViewAnimation.fade(duration: 0.5, consecutively: true)
```

![](images/Animations/fade.gif)


### Constructing your own complex animation using CGAffineTransform:

```swift
let degrees = CGFloat(sin(90.0 * M_PI/180.0))
let rotationTransform = CGAffineTransform(rotationAngle: degrees)
let translationTransform = CGAffineTransform(translationX: -300.0, y: 0.0)
let customTransform = rotationTransform.concatenating(translationTransform)

TableViewAnimation.custom(duration: 1.0, startingTransform: customTransform, staggered: true)
```


## Installation
You can use [CocoaPods](http://cocoapods.org/) to install `Tableau` by adding it to your `Podfile`:

```swift
platform :ios, '8.0'
use_frameworks!

pod 'Tableau'
```

Or install it manually by downloading `UITableView+Animations.swift` and dropping it in your project.

## About me

Hi, I'm [Joe](http://fabisevi.ch) everywhere on the web, but especially on [Twitter](https://twitter.com/mergesort).

## License

See the [license](LICENSE) for more information about how you can use Tableau.

## Fin

Now get to animating without having to worry about UITableView's state.

![](images/gaga.gif)

## P.S.

If all you liked was the kitty, that's my baby Gif. Feel free to follow her on the [Instagram](https://www.instagram.com/gifthecat).