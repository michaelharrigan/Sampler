//
//  ForecastFetcher.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/27/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForecastFetcher: NSObject {

    let darkSkyAPIKey = APIKeys.DARKSKY
    let urlToFetch: URL?

    // (https://www.swiftbysundell.com/articles/constructing-urls-in-swift/)
    init(longitude: Double, latitude: Double) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.darksky.net"
        components.path = "/forecast/\(darkSkyAPIKey)/\(latitude),\(longitude)"

        self.urlToFetch = components.url
    }

    func fetchForecat(completion: @escaping (_ fetchedData: FullForecastModel) -> Void) {

        // Asynchronous call to Dark Sky API url, using URLSession:
        URLSession.shared.dataTask(with: self.urlToFetch!) { (data, response, error) -> Void in

            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Data we are going to use
                    let responseData = try JSONDecoder().decode(FullForecastModel.self, from: data!)

                    // Create forecast model from the data
                    let forecast = ForecastModelCreator().createForecastModel(jsonResponse: responseData)

                    // Send that completion
                    completion(forecast)
                } catch {
                    // Something went wrong
                    assertionFailure("Error: \(error) with response: \(String(describing: response))")
                }
            }
        }.resume()
    }
}
