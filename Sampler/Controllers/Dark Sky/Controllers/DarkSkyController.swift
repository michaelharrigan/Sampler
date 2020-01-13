//
//  SecondViewController.swift
//  Sampler
//
//  Created by Michael Harrigan on 12/24/19.
//  Copyright © 2019 Michael Harrigan. All rights reserved.
//

import UIKit

class DarkSkyController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    let sharedLocation = LocationHelper.shared
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    // Outlets
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var summary: UILabel?
    @IBOutlet weak var nearestStromDistance: UILabel?
    @IBOutlet weak var precipIntensity: UILabel?
    @IBOutlet weak var precipIntensityError: UILabel?
    @IBOutlet weak var precipProbabilty: UILabel?
    @IBOutlet weak var precipType: UILabel?
    @IBOutlet weak var apparentTemperature: UILabel?
    @IBOutlet weak var dewPoint: UILabel?
    @IBOutlet weak var humidity: UILabel?
    @IBOutlet weak var pressure: UILabel?
    @IBOutlet weak var windSpeed: UILabel?
    @IBOutlet weak var windGust: UILabel?
    @IBOutlet weak var windBearing: UILabel?
    @IBOutlet weak var cloudCover: UILabel?
    @IBOutlet weak var uvIndex: UILabel?
    @IBOutlet weak var visibilty: UILabel?
    @IBOutlet weak var ozone: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.showActivityIndicatory(uiView: self.view)
            self.setup()
        }
    }

    func setup() {
        sharedLocation.authorize()
        LocationHelper.shared.locate { (result) in
            switch result {
            case .success(self.sharedLocation):
                let forecastObject = ForecastFetcher.init(longitude:
                    "\(self.sharedLocation.location?.coordinate.longitude ?? 0)",
                    latitude: "\(self.sharedLocation.location?.coordinate.latitude ?? 0)")
                forecastObject.fetchForecat { (forecast) in
                    let currentForecast = forecast.currently
                    let roundedTemperature = Int(String(format: "%.0f",
                                                        forecast.currently.temperature.rounded()))
                    self.temperatureLabel!.text = "\(roundedTemperature ?? 0)°"
                    self.icon.image = forecast.currently.icon
                    self.summary!.text = "Summary: \(currentForecast.summary)"
                    self.nearestStromDistance!.text = "Nearest Storm Distance: \(currentForecast.nearestStormDistance)"
                    self.precipIntensity!.text = "Precip Intensity: \(currentForecast.precipIntensity)"
                    self.precipIntensityError!.text = "Precip Intensity Error: \(currentForecast.precipIntensityError)"
                    self.precipProbabilty!.text = "Precip Probability: \(currentForecast.precipProbabilty)"
                    self.precipType!.text = "Precip Type: \(currentForecast.precipType)"
                    self.apparentTemperature!.text = "Feels Like: \(currentForecast.apparentTemperature)"
                    self.dewPoint!.text = "Dew Point: \(currentForecast.dewPoint)"
                    self.humidity!.text = "Humidity: \(currentForecast.humidity)"
                    self.pressure!.text = "Pressure: \(currentForecast.pressure)"
                    self.windSpeed!.text = "Wind Speed: \(currentForecast.windSpeed)"
                    self.windGust!.text = "Wind Gust: \(currentForecast.windGust)"
                    self.windBearing!.text = "Windbearing: \(currentForecast.windBearing)"
                    self.cloudCover!.text = "Cloud Cover: \(currentForecast.cloudCover)"
                    self.uvIndex!.text = "UV Index: \(currentForecast.uvIndex)"
                    self.visibilty!.text = "Visibilty: \(currentForecast.visibility)"
                    self.ozone!.text = "Ozone: \(currentForecast.ozone)"
                    self.activityIndicator.stopAnimating()
                }
            case .failure:
                print("FAIL")
            default: break
            }
        }
    }

    func showActivityIndicatory(uiView: UIView) {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            UIActivityIndicatorView.Style.gray
        uiView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
