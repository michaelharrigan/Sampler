//
//  MainCoordinator.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/24/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.tintColor = .label
        } else {
            // Fallback on earlier versions
        }
    }

    func start() {
        let initialTableViewController = InitialTableViewController.instantiate()
        initialTableViewController.coordinator = self
        navigationController.pushViewController(initialTableViewController, animated: false)
    }

    func darkSky() {
        let darkSkyViewController = DarkSkyController.instantiate()
        darkSkyViewController.coordinator = self
        navigationController.pushViewController(darkSkyViewController, animated: true)
    }
}
