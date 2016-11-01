//
//  Created by Joe Fabisevich on 9/30/16.
//  Copyright © 2016 mergesort. All rights reserved.
//

import UIKit

public enum TableViewAnimation {

    case left(duration: TimeInterval, staggered: Bool)
    case right(duration: TimeInterval, staggered: Bool)
    case top(duration: TimeInterval)
    case bottom(duration: TimeInterval)
    case fade(duration: TimeInterval, consecutively: Bool)
    case custom(duration: TimeInterval, startingTransform: CGAffineTransform, staggered: Bool)

    fileprivate enum AnimationDirection {

        case left
        case right
        case top
        case bottom

        func xPosition(cell: UITableViewCell) -> CGFloat {
            if case .left = self {
                return -cell.frame.width
            } else if case .right = self {
                return cell.frame.width
            } else {
                return 0
            }
        }

        func yPosition(cell: UITableViewCell) -> CGFloat {
            if case .top = self {
                return cell.frame.height
            } else if case .bottom = self {
                return -cell.frame.height
            } else {
                return 0
            }
        }

    }

}

public extension UITableView {

    public func animateRows(animation: TableViewAnimation) {
        switch animation {

        case .left(let duration, let staggered):
            self.animateTableViewWithDirection(duration: duration, direction: .left, staggered: staggered, strongDamping: false)

        case .right(let duration, let staggered):
            self.animateTableViewWithDirection(duration: duration, direction: .right, staggered: staggered, strongDamping: false)

        case .top(let duration):
            self.animateTableViewWithDirection(duration: duration, direction: .top, staggered: false, strongDamping: true)

        case .bottom(let duration):
            self.animateTableViewWithDirection(duration: duration, direction: .bottom, staggered: false, strongDamping: false)

        case .fade(let duration, let consecutively):
            self.animateTableViewWithFade(duration: duration, consecutively: consecutively)

        case .custom(let duration, let startingTransform, let staggered):
            self.animateTableViewWithTransform(duration: duration, transform: startingTransform, staggered: staggered)

        }
    }

    public func reloadTableViewWithFadeAnimation(duration: TimeInterval = 0.3) {
        self.reloadData()

        self.animateTableViewWithFade(duration: duration, consecutively: false)
    }

    public func reloadTableViewSmoothly() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()

        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }

        self.reloadData()
        self.beginUpdates()
        self.endUpdates()

        CATransaction.commit()
    }

}

fileprivate extension UITableView {

    func animateTableViewWithTransform(duration: TimeInterval, transform: CGAffineTransform, staggered: Bool) {
        for (index, cell) in self.visibleCells.enumerated() {
            let delay: TimeInterval = staggered ? duration/Double(self.visibleCells.count)*Double(index) : 0.0
            let damping: CGFloat = staggered ? 0.55 : 0.75

            cell.layer.setAffineTransform(transform)

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                cell.layer.setAffineTransform(.identity)
            }, completion: nil)
        }
    }

    func animateTableViewWithDirection(duration: TimeInterval, direction: TableViewAnimation.AnimationDirection, staggered: Bool, strongDamping: Bool) {
        for (index, cell) in self.visibleCells.enumerated() {
            let delay: TimeInterval = staggered ? duration/Double(self.visibleCells.count)*Double(index) : 0.0
            let damping: CGFloat = staggered ? 0.55 : 0.75

            let cellTransform = CGAffineTransform(translationX: direction.xPosition(cell: cell), y: direction.yPosition(cell: cell))
            cell.layer.setAffineTransform(cellTransform)

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                cell.layer.setAffineTransform(.identity)
            }, completion: nil)
        }
    }

    func animateTableViewWithFade(duration: TimeInterval, consecutively: Bool) {
        if consecutively {
            for (index, cell) in self.visibleCells.enumerated() {
                let animationDelay: TimeInterval = duration/Double(visibleCells.count)*Double(index)

                cell.alpha = 0.0
                UIView.animate(withDuration: duration, delay: animationDelay, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: nil)
            }
        } else {
            let animation = UITableView.fadeAnimationTransition
            animation.duration = duration

            self.layer.add(animation, forKey: "UITableViewReloadDataAnimationKey")
        }
    }

    static let fadeAnimationTransition: CATransition = {
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeBoth

        return animation
    }()

}
