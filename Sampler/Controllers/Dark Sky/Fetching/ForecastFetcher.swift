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

    // TODO: We should be using URL Params
    // (https://www.swiftbysundell.com/articles/constructing-urls-in-swift/)
    init(longitude: String, latitude: String) {
        let api = "https://api.darksky.net"
        let endPoint = "/forecast"
        let apiKey = "/\(darkSkyAPIKey)"
        let latitude = "/\(latitude),"
        let longitude = longitude

        self.urlToFetch = URL(string: api + endPoint + apiKey + latitude + longitude)
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
                    let forecast = self.createForecastModel(jsonResponse: responseData)

                    // Send that completion
                    completion(forecast)
                } catch {
                    // Something went wrong
                    // TODO: Proper Errors
                }
            }
        }.resume()
    }

    func createForecastModel(jsonResponse: FullForecastModel) -> FullForecastModel {

        let currently = jsonResponse.currently
        var currentForecastModel = CurrentForecastModel()
        currentForecastModel.time = currently.time
        currentForecastModel.summary = currently.summary
        currentForecastModel.icon = currently.icon
        currentForecastModel.nearestStormDistance = currently.nearestStormDistance
        currentForecastModel.precipIntensity = currently.precipIntensity
        currentForecastModel.precipIntensityError = currently.precipIntensityError
        currentForecastModel.precipProbabilty = currently.precipProbabilty
        currentForecastModel.precipType = currently.precipType
        currentForecastModel.temperature = currently.temperature
        currentForecastModel.apparentTemperature = currently.apparentTemperature
        currentForecastModel.dewPoint = currently.dewPoint
        currentForecastModel.humidity = currently.humidity
        currentForecastModel.pressure = currently.pressure
        currentForecastModel.windSpeed = currently.windSpeed
        currentForecastModel.windGust = currently.windGust
        currentForecastModel.windBearing = currently.windBearing
        currentForecastModel.cloudCover = currently.cloudCover
        currentForecastModel.uvIndex = currently.uvIndex
        currentForecastModel.visibility = currently.visibility
        currentForecastModel.ozone = currently.ozone

        let forecast = FullForecastModel(latitude: jsonResponse.latitude,
                                         longitude: jsonResponse.longitude,
                                         timezone: jsonResponse.timezone,
                                         currently: currentForecastModel)

        return forecast
    }

    public func chooseProperIcon(icon: String) -> UIImage? {

        var finalImage: UIImage?
        let imageDictionary = ["clear-night": "moon.stars",
                               "clear-day": "sun.min",
                               "rain": "cloud.drizzle",
                               "snow": "snow",
                               "sleet": "wind.snow",
                               "wind": "wind",
                               "fog": "cloud.fog",
                               "cloudy": "cloud",
                               "partly-cloudy-day": "cloud.sun",
                               "partly-cloudy-night": "cloud.moon"]

        if #available(iOS 13.0, *) {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .black, scale: .large)
            finalImage = UIImage(systemName: imageDictionary[icon] ?? "sun.min", withConfiguration: imageConfig)
        } else {
            // Fallback on earlier versions
            #warning("Need to add iOS 12 images!")
        }

        return finalImage
    }
}
