//
//  ViewController.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/24/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import UIKit

class InitialTableViewController: UITableViewController, Storyboarded {

    var coordinator: MainCoordinator?

    let coordinatorArray = ["Dark Sky"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 13.0, *) {
            self.tableView = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
      navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                          style: .done,
                                                          target: self,
                                                          action: #selector(settingsButtonTapped))
        } else {
            // Fallback on earlier versions
            self.tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinatorArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
        cell.textLabel?.text = "\(coordinatorArray[indexPath.row])"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add factory method here to check name of row and map to
        mapTheController(rowTitle: coordinatorArray[indexPath.row])
    }

    // MARK: - Factory Mapping
    func mapTheController(rowTitle: String) {

        let functionMapping: [String: Int] = ["Dark Sky": 0]

        switch functionMapping[rowTitle] {
        case 0:
            coordinator?.darkSky()
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }

    @objc func settingsButtonTapped(sender: UIButton) {
        print("Tapped")
    }
}
