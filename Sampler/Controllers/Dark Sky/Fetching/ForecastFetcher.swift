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

    func fetchForecat(completion:(_ fetchedData: FullForecastModel) -> Void) {
        do {
            let jsonResponse = try JSON(data: Data(contentsOf: urlToFetch!))
            if !jsonResponse.isEmpty {
                let forecast = createForecastModel(jsonResponse: jsonResponse)
                completion(forecast)
            }
        } catch {
        }
    }

    func createForecastModel(jsonResponse: JSON) -> FullForecastModel {

        let currentForecastResponse = jsonResponse["currently"]
        let time = currentForecastResponse["time"].floatValue
        let summary = currentForecastResponse["summary"].stringValue
        let icon = chooseProperIcon(icon: currentForecastResponse["icon"].stringValue)
        let nearestStormDistance = currentForecastResponse["nearestStromDistance"].floatValue
        let preciptIntensity = currentForecastResponse["precipIntensity"].floatValue
        let precipIntensityError = currentForecastResponse["precipIntensityError"].floatValue
        let precipProbability = currentForecastResponse["precipProbabilty"].floatValue
        let precipType = currentForecastResponse["precipType"].stringValue
        let temperature = currentForecastResponse["temperature"].doubleValue
        let apparentTemperature = currentForecastResponse["apparentTemperature"].doubleValue
        let dewPoint = currentForecastResponse["dewPoint"].doubleValue
        let humidity = currentForecastResponse["humidity"].floatValue
        let pressure = currentForecastResponse["pressure"].doubleValue
        let windSpeed = currentForecastResponse["windSpeed"].doubleValue
        let windGust = currentForecastResponse["windGust"].doubleValue
        let windBearing = currentForecastResponse["windBearing"].intValue
        let cloudCover = currentForecastResponse["cloudCover"].floatValue
        let uvIndex = currentForecastResponse["uvIndex"].intValue
        let visibility = currentForecastResponse["visibilty"].doubleValue
        let ozone = currentForecastResponse["ozone"].floatValue

        var currentForecastModel = CurrentForecastModel()
        currentForecastModel.time = time
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

        let forecast = FullForecastModel(latitude: jsonResponse["latitude"].floatValue,
                                         longitude: jsonResponse["longitude"].floatValue,
                                         timezone: jsonResponse["timezone"].stringValue,
                                         currently: currentForecastModel)

        return forecast
    }

    func chooseProperIcon(icon: String) -> UIImage? {

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
