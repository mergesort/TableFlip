//
//  ViewController.swift
//  TableFlipExample
//
//  Created by Joe Fabisevich on 8/27/17.
//  Copyright © 2017 Mergesort. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill

        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

}

private extension ViewController {
    
    func setup() {
        self.title = "Animations"
        self.edgesForExtendedLayout = []
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8549019608, green: 0.2352941176, blue: 0.4705882353, alpha: 1)
        
        self.view.addSubview(self.stackView)

        let topAnimationButton = self.makeButton(title: "Top Animation", backgroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), selector: #selector(tappedTopAnimationButton))
        self.stackView.addArrangedSubview(topAnimationButton)
        
        let fadeAnimationButton = self.makeButton(title: "Fade Animation", backgroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), selector: #selector(tappedFadeAnimationButton))
        self.stackView.addArrangedSubview(fadeAnimationButton)
        
        let leftAnimationButton = self.makeButton(title: "Left Animation", backgroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), selector: #selector(tappedLeftAnimationButton))
        self.stackView.addArrangedSubview(leftAnimationButton)
        
        let customAnimationButton = self.makeButton(title: "Custom Animation", backgroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), selector: #selector(tappedCustomAnimationButton))
        self.stackView.addArrangedSubview(customAnimationButton)

        let indexPathsAnimationButton = self.makeButton(title: "Index Paths Animation", backgroundColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), selector: #selector(tappedIndexPathAnimationButton))
        self.stackView.addArrangedSubview(indexPathsAnimationButton)

        self.setupConstraints()
    }

    func setupConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    func pushTableViewController(animation: ExampleAnimation) {
        let tableViewController = TableViewController(animation: animation)
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func makeButton(title: String, backgroundColor: UIColor, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.addTarget(self, action: selector, for: .touchUpInside)

        return button
    }

    @objc func tappedTopAnimationButton() {
        self.pushTableViewController(animation: .top)
    }
    
    @objc func tappedFadeAnimationButton() {
        self.pushTableViewController(animation: .fade)
    }
    
    @objc func tappedCustomAnimationButton() {
        self.pushTableViewController(animation: .custom)
    }

    @objc func tappedLeftAnimationButton() {
        self.pushTableViewController(animation: .left)
    }
    
    @objc func tappedIndexPathAnimationButton() {
        self.pushTableViewController(animation: .indexPaths)
    }
}
