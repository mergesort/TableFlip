//
//  TableViewController.swift
//  TableFlipExample
//
//  Created by Joe Fabisevich on 8/27/17.
//  Copyright © 2017 Mergesort. All rights reserved.
//

import UIKit

enum ExampleAnimation {
    case fade
    case top
    case left
    case custom
    case indexPaths
}

final class TableViewController: UIViewController {

    private let animation: ExampleAnimation

    private let dataSource = ExampleDataSource()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 64.0
        tableView.tableFooterView = UIView()
        
        return tableView
    }()

    // MARK: Initializers

    init(animation: ExampleAnimation) {
        self.animation = animation

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unimplemented, and loving it.")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

}

private extension TableViewController {
    
    func setup() {
        self.tableView.dataSource = self.dataSource

        self.view.addSubview(self.tableView)

        self.title = self.animation.title

        self.setupConstraints()

        // Delayed to simulate a network connection, like in the real world, which is where I live.
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.dataSource.hasLoaded = true
            self.tableView.reloadData()
            self.animateTableView()
        }
    }

    func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    func animateTableView() {
        switch self.animation {

        case .top:
            let topAnimation = TableViewAnimation.Table.top(duration: 0.8)
            self.tableView.animate(animation: topAnimation)

        case .fade:
            let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.3)
            self.tableView.animate(animation: fadeAnimation)

        case .left:
            let leftAnimation = TableViewAnimation.Cell.left()
            self.tableView.animate(animation: leftAnimation, indexPaths: nil, completion: nil)

        case .custom:
            let degrees = sin(90.0 * CGFloat.pi/180.0)
            let rotationTransform = CGAffineTransform(rotationAngle: degrees)
            let flipTransform = CGAffineTransform(scaleX: -1, y: -1)
            let customTransform = rotationTransform.concatenating(flipTransform)
            let customAnimation = TableViewAnimation.Cell.custom(duration: 0.6, transform: customTransform, options: .curveEaseInOut)

            self.tableView.animate(animation: customAnimation, completion: nil)

        case .indexPaths:
            let groupedItems = Dictionary(grouping: (0..<self.dataSource.exampleItems.count), by: { $0 % 2 })

            let oddIndices = groupedItems[1]?.compactMap { IndexPath(row: $0, section: 0) }
            let leftAnimation = TableViewAnimation.Cell.left()
            self.tableView.animate(animation: leftAnimation, indexPaths: oddIndices, completion: nil)

            let evenIndices = groupedItems[0]?.compactMap { IndexPath(row: $0, section: 0) }
            let rightAnimation = TableViewAnimation.Cell.right()
            self.tableView.animate(animation: rightAnimation, indexPaths: evenIndices, completion: nil)
        }
    }
    
}

private extension ExampleAnimation {

    var title: String {
        switch self {
            case .custom:
                return "Custom Animation"

            case .top:
                return "Top Animation"

            case .left:
                return "Left Animation"

            case .fade:
                return "Fade Animation"

            case .indexPaths:
                return "Select Index Paths Animation"
        }
    }

}
