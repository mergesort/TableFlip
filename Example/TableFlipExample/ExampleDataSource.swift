//
//  ExampleDataSource.swift
//  TableFlipExample
//
//  Created by Joe Fabisevich on 11/10/19.
//  Copyright © 2019 Mergesort. All rights reserved.
//

import UIKit

struct CellData {
    let title: String
    let subtitle: String
    let image: UIImage?
}

final class ExampleDataSource: NSObject, UITableViewDataSource {

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
