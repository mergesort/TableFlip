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

        self.setupConstraints()

        switch self.animation {

        case .custom:
            self.title = "Custom Animation"
            
        case .top:
            self.title = "Top Animation"
            
        case .left:
            self.title = "Left Animation"
            
        case .fade:
            self.title = "Fade Animation"
            
        case .indexPaths:
            self.title = "Select Index Paths Animation"
            
        }
        
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
            self.tableView.animateTableView(animation: topAnimation)

        case .fade:
            let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.5)
            self.tableView.animateCells(animation: fadeAnimation)

        case .left:
            let leftAnimation = TableViewAnimation.Cell.left(duration: 0.5)
            self.tableView.animateCells(animation: leftAnimation, indexPaths: nil, completion: nil)

        case .custom:
            let degrees = sin(90.0 * CGFloat.pi/180.0)
            let rotationTransform = CGAffineTransform(rotationAngle: degrees)
            let flipTransform = CGAffineTransform(scaleX: -1, y: -1)
            let customTransform = rotationTransform.concatenating(flipTransform)

            let customAnimation = TableViewAnimation.Cell.custom(duration: 0.6, transform: customTransform, options: .curveEaseInOut)

            self.tableView.animateCells(animation: customAnimation, completion: nil)

        case .indexPaths:
            let evenIndices = (0..<self.dataSource.exampleItems.count).flatMap { return ($0 % 2 == 0) ? IndexPath(row: $0, section: 0) : nil }
            let rightAnimation = TableViewAnimation.Cell.right(duration: 0.5)
            self.tableView.animateCells(animation: rightAnimation, indexPaths: evenIndices, completion: nil)

        }
    }
    
}

private struct CellData {
    
    let title: String
    let subtitle: String
    let image: UIImage?

}

private final class ExampleDataSource: NSObject, UITableViewDataSource {

    var hasLoaded: Bool = false

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasLoaded ? self.exampleItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        let currentCellData = self.exampleItems[indexPath.row]

        cell.textLabel?.text = currentCellData.title
        cell.detailTextLabel?.text = currentCellData.subtitle
        cell.imageView?.image = currentCellData.image

        return cell
    }

    let exampleItems: [CellData] = [
        CellData(title: "Playing Astronaut", subtitle: "Age: 12 months", image: #imageLiteral(resourceName: "playing_astronaut")),
        CellData(title: "Fetching", subtitle: "Age: 3 months", image: #imageLiteral(resourceName: "fetching")),
        CellData(title: "Being Adorable", subtitle: "Age: 7 months", image: #imageLiteral(resourceName: "being_adorable")),
        CellData(title: "Buying Sneakers", subtitle: "Age: 10 months", image: #imageLiteral(resourceName: "buying_sneakers")),
        CellData(title: "Napping", subtitle: "Age: 4 months", image: #imageLiteral(resourceName: "napping")),
        CellData(title: "Breathing Deeply", subtitle: "Age: 9 months", image: #imageLiteral(resourceName: "breathing_deeply")),
        CellData(title: "Camouflaging", subtitle: "Age: 8 months", image: #imageLiteral(resourceName: "camouflaging")),
        CellData(title: "Screaming Her Butt Off", subtitle: "Age: 2 months", image: #imageLiteral(resourceName: "screaming_her_but_off")),
    ]

}
