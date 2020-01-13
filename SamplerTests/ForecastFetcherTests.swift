//
//  ForecastFetcherTests.swift
//  ForecastFetcherTests
//
//  Created by Michael Harrigan on 12/24/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import XCTest
@testable import Sampler
import CoreLocation

class ForecastFetcherTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testPositiveReturn() {

        for _ in 0...100 {
            let coordinates = generateRandomCoordinates(min: 0, max: 200)
            let longitude = String(describing: coordinates.longitude)
            let latitude = String(describing: coordinates.latitude)
            let forecast = ForecastFetcher(longitude: longitude, latitude: latitude)

            let urlToFetch = forecast.urlToFetch
            let urlString = "https://api.darksky.net/forecast/\(APIKeys.DARKSKY)/\(latitude),\(longitude)"
            let matchingUrl = URL(string: urlString)
            XCTAssertEqual(urlToFetch, matchingUrl, "The URL is incorrect!")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let coordinates = generateRandomCoordinates(min: 0, max: 200)
            let longitude = String(describing: coordinates.longitude)
            let latitude = String(describing: coordinates.latitude)
            _ = ForecastFetcher(longitude: longitude, latitude: latitude)
        }
    }
}

extension ForecastFetcherTests {

    func generateRandomCoordinates(min: UInt32, max: UInt32) -> CLLocationCoordinate2D {

        //Get the Current Location's longitude and latitude
        let currentLong = LocationHelper.shared.location?.coordinate.longitude
        let currentLat = LocationHelper.shared.location?.coordinate.latitude

        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000

        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)

        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)

        // Then we convert the distance in
        // meters to coordinates by Multiplying the
        // number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)

        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat! + metersCordN, longitude: currentLong! + metersCordN)
        } else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong! - metersCordN)
        } else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat! + metersCordN, longitude: currentLong! - metersCordN)
        } else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong! + metersCordN)
        } else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong! - metersCordN)
        } else {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong!)
        }

    }
}
