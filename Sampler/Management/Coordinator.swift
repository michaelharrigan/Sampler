//
//  Coordinator.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/24/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
