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
                    DispatchQueue.main.async {

                    let roundedTemperature = Int(String(format: "%.0f",
                                                        forecast.currently.temperature!.rounded()))
                    self.temperatureLabel!.text = "\(roundedTemperature ?? 0)°"
                    self.icon.image = forecastObject.chooseProperIcon(icon: forecast.currently.icon!)
                    self.summary!.text = "Summary: \(currentForecast.summary ?? "Not Available")"
                    self.nearestStromDistance!.text = "Nearest Storm Distance: \(currentForecast.nearestStormDistance ??  0)"
                    self.precipIntensity!.text = "Precip Intensity: \(currentForecast.precipIntensity ??  0)"
                    self.precipIntensityError!.text = "Precip Intensity Error: \(currentForecast.precipIntensityError ??  0)"
                    self.precipProbabilty!.text = "Precip Probability: \(currentForecast.precipProbabilty ??  0)"
                        self.precipType!.text = "Precip Type: \(currentForecast.precipType?.rawValue ?? "N/A")"
                    self.apparentTemperature!.text = "Feels Like: \(currentForecast.apparentTemperature ?? 0)"
                    self.dewPoint!.text = "Dew Point: \(currentForecast.dewPoint ??  0)"
                    self.humidity!.text = "Humidity: \(currentForecast.humidity ??  0)"
                    self.pressure!.text = "Pressure: \(currentForecast.pressure ??  0)"
                    self.windSpeed!.text = "Wind Speed: \(currentForecast.windSpeed ??  0)"
                    self.windGust!.text = "Wind Gust: \(currentForecast.windGust ?? 0)"
                    self.windBearing!.text = "Windbearing: \(currentForecast.windBearing ?? 0)"
                    self.cloudCover!.text = "Cloud Cover: \(currentForecast.cloudCover ??  0)"
                    self.uvIndex!.text = "UV Index: \(currentForecast.uvIndex ?? 0)"
                    self.visibilty!.text = "Visibilty: \(currentForecast.visibility ?? 0)"
                    self.ozone!.text = "Ozone: \(currentForecast.ozone ?? 0)"
                    self.activityIndicator.stopAnimating()
                    }
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
