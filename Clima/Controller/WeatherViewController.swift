//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()

  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchInput: UITextField!
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set controller delegates
    locationManager.delegate = self
    searchInput.delegate = self
    weatherManager.delegate = self
    
    // Call location services
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  @IBAction func handleGetCurrentLocationWeather(_ sender: UIButton) {
    locationManager.requestLocation()
  }
  
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
  
  @IBAction func handleSearch(_ sender: UIButton) {
    searchInput.endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let currentText = searchInput.text
    searchInput.endEditing(true)
    
    if currentText != "" {
      return true
    }
    
    return false
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      searchInput.placeholder = "Please enter a location"
      return false
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let location = searchInput.text {
      weatherManager.getWeatherBy(cityName: location)
    }
    
    searchInput.text = ""
  }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
  
  func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
    DispatchQueue.main.async {
      self.cityLabel.text = weather.cityName
      self.conditionImageView.image = UIImage(systemName: weather.conditionName)
      self.temperatureLabel.text = String(format: "%0.f", weather.temperature)
    }
  }
  
  func didEndWithError(_ error: Error) {
    print(error)
  }
}

// MARK: - CLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // stop updating location as soon a location is found
    self.locationManager.stopUpdatingLocation()
    
    // get the location data from the gps
    let currentLocation = locations[locations.count - 1]
    let latitude = currentLocation.coordinate.latitude
    let longitude = currentLocation.coordinate.longitude

    // fetch the weather from the current location data]
    self.weatherManager.getWeatherBy(latitude: latitude, longitude: longitude)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
    print("Error getting current location")
  }
}
