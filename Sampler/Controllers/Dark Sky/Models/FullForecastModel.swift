//
//  ForecastModel.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/27/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//
// swiftlint:disable line_length
import Foundation
import UIKit
import CoreLocation
// TODO: Make both of the objects below Codable so we can conform to the model
/// The full forecast including current, hourly, minutely.
struct FullForecastModel {

    /// The request latitude.
    let latitude: Float32

    /// The requested longitude.
    let longitude: Float32

    /// Example (America/New_York) The IANA timezone name for the requested location. This is used for text summaries and for determining when hourly and daily data block objects begin.
    let timezone: String

    /// This is the data for the current weather conditions at the requested locaiton.
    let currently: CurrentForecastModel
}

/// This is the data for the current weather conditions at the requested locaiton.
struct CurrentForecastModel {

    /// The UNIX time at which this data point begins.
    ///
    /// `minutely` data point are always aligned to the top of the minute,
    ///  hourly data point objects to the top of the hour,
    ///  `daily` data point objects to midnight of the day, and `currently` data
    /// point object to the point of time provided all according to the local time zone.
    var time: Float32 = 0

    /// A human-readable text summary of this data point.
    ///
    /// (This property has millions of possible values, so don’t use it for automated purposes: use the icon property, instead!)
    var summary: String = ""

    /// A machine-readable text summary of this data point, suitable for selecting an icon for display.
    ///
    /// If defined, this property will have one of the following values: clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night.
    ///
    /// (Developers should ensure that a sensible default is defined, as additional values, such as hail, thunderstorm, or tornado, may be defined in the future.)
    var icon: UIImage?

    /// The approximate distance to the nearest storm in miles.
    ///
    ///  (A storm distance of `0` doesn’t necessarily refer to a storm at the requested location, but rather a storm in the vicinity of that location.)
    var nearestStormDistance: Float32 = 0

    /// The intensity (in inches of liquid water per hour) of precipitation occurring at the given time. This value is conditional on probability (that is, assuming any precipitation occurs at all).
    var precipIntensity: Float32 = 0

    /// The standard deviation of the distribution of `precipIntensity`. (We only return this property when the full distribution, and not merely the expected mean, can be estimated with accuracy.)
    var precipIntensityError: Float32 = 0

    /// The probability of precipitation occurring, between `0` and `1`, inclusive.
    var precipProbabilty: Float32 = 0

    /// The type of precipitation occurring at the given time. If defined, this
    /// property will have one of the following values: `"rain"`, `"snow"`, or `"sleet"` (which refers to each of freezing rain, ice pelvars, and “wintery mix”).
    ///
    /// (If `precipIntensity` is zero, then this property will not be defined.
    /// Additionally, due to the lack of data in our sources, historical `precipType` information is usually estimated, rather than observed.)
    var precipType: String = ""

    /// The air temperature in degrees Fahrenheit.
    var temperature: Double = 0

    /// The apparent (or “feels like”) temperature in degrees Fahrenheit.
    var apparentTemperature: Double = 0

    /// The dew point in degrees Fahrenheit.
    var dewPoint: Double = 0

    /// The relative humidity, between 0 and 1, inclusive.
    var humidity: Float32 = 0

    /// The sea-level air pressure in millibars.
    var pressure: Double = 0

    /// The wind speed in miles per hour.
    var windSpeed: Double = 0

    /// The wind gust speed in miles per hour.
    var windGust: Double = 0

    /// The direction that the wind is coming **from** in degrees, with true north at 0° and progressing clockwise.
    ///
    /// (If `windSpeed` is zero, then this value will not be defined.)
    var windBearing: Int = 0

    /// The percentage of sky occluded by clouds, between 0 and 1, inclusive.
    var cloudCover: Float32 = 0

    /// The UV index.
    var uvIndex: Int = 0

    /// The average visibility in miles, capped at 10 miles.
    var visibility: Double = 0

    /// The columnar density of total atmospheric ozone at the given time in Dobson units.
    var ozone: Float32 = 0
}

/// The type of precipitation occurring at the given time.
enum PrecipType {

    case rain
    case snow
    case sleet

    /// This means the property is zero
    case notDefined
}
