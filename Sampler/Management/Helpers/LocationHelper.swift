//
//  LocationHelper.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/27/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {

    enum Result<T> {
        case success(T)
        case failure
    }

    static let shared: LocationHelper = LocationHelper()

    typealias Callback = (Result <LocationHelper>) -> Void

    var requests: [Callback] = [Callback]()

    var location: CLLocation { return sharedLocationManager.location! }

    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationManager = CLLocationManager()
        newLocationManager.delegate = self
        return newLocationManager
    }()

    // MARK: - Authorization

    class func authorize() { shared.authorize() }

    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }

    // MARK: - Helpers

    func locate(callback: @escaping (Callback)) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }

    func reset() {
        self.requests = [Callback]()
        sharedLocationManager.stopUpdatingLocation()
    }

    // MARK: - Delegate

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        for request in self.requests { request(.failure) }
                for request in self.requests { request(.failure) }
        self.reset()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for request in self.requests { request(.success(self)) }
        self.reset()
    }

}
