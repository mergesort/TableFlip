//
//  Created by Joe Fabisevich on 9/30/16.
//  Copyright © 2016 mergesort. All rights reserved.
//

import UIKit

public enum TableViewAnimation {

    public enum Table {

        case top(duration: TimeInterval)
        case bottom(duration: TimeInterval)
        case fade(duration: TimeInterval)
        case custom(duration: TimeInterval, transform: CGAffineTransform, options: UIViewAnimationOptions)

        fileprivate enum AnimationDirection {

            case top
            case bottom

            func yPosition(tableView: UITableView) -> CGFloat {
                if case .top = self {
                    return -tableView.frame.height
                } else if case .bottom = self {
                    return tableView.frame.height
                } else {
                    return 0
                }
            }

        }
    }

    public enum Cell {

        case left(duration: TimeInterval)
        case right(duration: TimeInterval)
        case fade(duration: TimeInterval)
        case custom(duration: TimeInterval, transform: CGAffineTransform, options: UIViewAnimationOptions)

        fileprivate enum AnimationDirection {

            case left
            case right

            func xPosition(cell: UITableViewCell) -> CGFloat {
                if case .left = self {
                    return -cell.frame.width
                } else if case .right = self {
                    return cell.frame.width
                } else {
                    return 0
                }
            }

        }
    }

}

public extension UITableView {

    func animateTableView(animation: TableViewAnimation.Table, completion: (() -> Void)? = nil) {
        switch animation {

        case .top(let duration):
            self.animateTableViewWithDirection(duration: duration, direction: .top, completion: completion)

        case .bottom(let duration):
            self.animateTableViewWithDirection(duration: duration, direction: .bottom, completion: completion)

        case .fade(let duration):
            self.animateWithFade(duration: duration, consecutively: false, completion: completion)

        case .custom(let duration, let transform, let animationOptions):
            self.animateTableViewWithTransform(duration: duration, transform: transform, options: animationOptions, completion: completion)

        }
    }

    func animateCells(animation: TableViewAnimation.Cell, completion: (() -> Void)? = nil) {
        switch animation {

        case .left(let duration):
            self.animateTableCellsWithDirection(duration: duration, direction: .left, completion: completion)

        case .right(let duration):
            self.animateTableCellsWithDirection(duration: duration, direction: .right, completion: completion)

        case .fade(let duration):
            self.animateWithFade(duration: duration, consecutively: true, completion: completion)

        case .custom(let duration, let transform, let animationOptions):
            self.animateTableCellsWithTransform(duration: duration, transform: transform, options: animationOptions, completion: completion)

        }
    }

    func reloadData(smoothly: Bool, completion: (() -> Void)? = nil) {
        guard smoothly else {
            self.reloadData()
            return
        }

        UIView.setAnimationsEnabled(false)
        CATransaction.begin()

        CATransaction.setCompletionBlock {
            UIView.setAnimationsEnabled(true)
            completion?()
        }

        self.reloadData()
        self.beginUpdates()
        self.endUpdates()
        
        CATransaction.commit()
    }

}

// MARK: UITableView animations

fileprivate extension UITableView {

    func animateTableViewWithTransform(duration: TimeInterval, transform: CGAffineTransform, options: UIViewAnimationOptions = .curveEaseInOut, completion: (() -> Void)? = nil) {
        self.layer.setAffineTransform(transform)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: options, animations: {
            self.layer.setAffineTransform(.identity)
        }, completion: { finished in
            completion?()
        })
    }

    func animateTableViewWithDirection(duration: TimeInterval, direction: TableViewAnimation.Table.AnimationDirection, completion: (() -> Void)? = nil) {
        let damping: CGFloat = 0.75

        let cellTransform = CGAffineTransform(translationX: 0.0, y: direction.yPosition(tableView: self))
        self.layer.setAffineTransform(cellTransform)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.layer.setAffineTransform(.identity)
        }, completion: { finished in
            completion?()
        })
    }

}

// MARK: UITableViewCell animations

fileprivate extension UITableView {

    func animateTableCellsWithDirection(duration: TimeInterval, direction: TableViewAnimation.Cell.AnimationDirection, completion: (() -> Void)? = nil) {
        for (index, cell) in self.visibleCells.enumerated() {
            let delay: TimeInterval = duration/Double(self.visibleCells.count)*Double(index)
            let damping: CGFloat = 0.55

            let cellTransform = CGAffineTransform(translationX: direction.xPosition(cell: cell), y: 0.0)
            cell.layer.setAffineTransform(cellTransform)

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                cell.layer.setAffineTransform(.identity)
            }, completion: { finished in
                completion?()
            })
        }

    }

    func animateTableCellsWithTransform(duration: TimeInterval, transform: CGAffineTransform, options: UIViewAnimationOptions = .curveEaseInOut, completion: (() -> Void)? = nil) {
        for (index, cell) in self.visibleCells.enumerated() {
            let delay: TimeInterval = duration/Double(self.visibleCells.count)*Double(index)
            let damping: CGFloat = 0.55

            cell.layer.setAffineTransform(transform)

            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: options, animations: {
                cell.layer.setAffineTransform(.identity)
            }, completion: { finished in
                completion?()
            })
        }
    }

}

// MARK: Shared UITableView + UITableViewCell animations

fileprivate extension UITableView {

    func animateWithFade(duration: TimeInterval, consecutively: Bool, completion: (() -> Void)? = nil) {
        if consecutively {
            for (index, cell) in self.visibleCells.enumerated() {
                let animationDelay: TimeInterval = duration/Double(visibleCells.count)*Double(index)

                cell.alpha = 0.0
                UIView.animate(withDuration: duration, delay: animationDelay, options: .curveEaseInOut, animations: {
                    cell.alpha = 1.0
                }, completion: { finished in
                    completion?()
                })
            }
        } else {
            let animation = UITableView.fadeAnimationTransition
            animation.duration = duration

            self.layer.add(animation, forKey: "UITableViewReloadDataAnimationKey")

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration*1000))) {
                completion?()
            }
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
