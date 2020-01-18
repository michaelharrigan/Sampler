//
//  ForecastFetcher.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/27/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//
// swiftlint:disable function_body_length
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

        // Asynchronous Http call to your api url, using URLSession:
        URLSession.shared.dataTask(with: self.urlToFetch!) { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Access specific key with value of type String
                    let properData = try JSONDecoder().decode(FullForecastModel.self, from: data!)
                    print(response?.suggestedFilename ?? "")
                    let forecast = self.createForecastModel(jsonResponse: properData)
                    completion(forecast)
                } catch {
                    // Something went wrong
                    print("Something went wrong")
                }
            }
        }.resume()
    }

    func createForecastModel(jsonResponse: FullForecastModel) -> FullForecastModel {

        _ = jsonResponse.currently
        let time = jsonResponse.timezone
        let summary = jsonResponse.currently.summary
        let icon = jsonResponse.currently.icon
        let nearestStormDistance = jsonResponse.currently.nearestStormDistance
        let preciptIntensity = jsonResponse.currently.precipIntensity
        let precipIntensityError = jsonResponse.currently.precipIntensityError
        let precipProbability = jsonResponse.currently.precipProbabilty
        let precipType = jsonResponse.currently.precipType
        let temperature = jsonResponse.currently.temperature
        let apparentTemperature = jsonResponse.currently.apparentTemperature
        let dewPoint = jsonResponse.currently.dewPoint
        let humidity = jsonResponse.currently.humidity
        let pressure = jsonResponse.currently.pressure
        let windSpeed = jsonResponse.currently.windSpeed
        let windGust = jsonResponse.currently.windGust
        let windBearing = jsonResponse.currently.windBearing
        let cloudCover = jsonResponse.currently.cloudCover
        let uvIndex = jsonResponse.currently.uvIndex
        let visibility = jsonResponse.currently.visibility
        let ozone = jsonResponse.currently.ozone

        var currentForecastModel = CurrentForecastModel()
        currentForecastModel.time = Double(time)
        currentForecastModel.summary = summary
        currentForecastModel.icon = icon
        currentForecastModel.nearestStormDistance = nearestStormDistance
        currentForecastModel.precipIntensity = preciptIntensity
        currentForecastModel.precipIntensityError = precipIntensityError
        currentForecastModel.precipProbabilty = precipProbability
        currentForecastModel.precipType = precipType
        currentForecastModel.temperature = temperature
        currentForecastModel.apparentTemperature = apparentTemperature
        currentForecastModel.dewPoint = dewPoint
        currentForecastModel.humidity = humidity
        currentForecastModel.pressure = pressure
        currentForecastModel.windSpeed = windSpeed
        currentForecastModel.windGust = windGust
        currentForecastModel.windBearing = windBearing
        currentForecastModel.cloudCover = cloudCover
        currentForecastModel.uvIndex = uvIndex
        currentForecastModel.visibility = visibility
        currentForecastModel.ozone = ozone

        let forecast = FullForecastModel(latitude: jsonResponse.latitude,
                                         longitude: jsonResponse.longitude,
                                         timezone: time,
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
