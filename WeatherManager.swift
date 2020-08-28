//
//  WeatherManager.swift
//  Clima
//
//  Created by Manuel Hernández on 21/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
  func didEndWithError(_ error: Error)
}

struct WeatherManager {
  let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
  let apiKey = "&appid=604e8540096d6ae0ff5d90598e12f508"
  let units = "&units=metric"
  
  var delegate: WeatherManagerDelegate?
  
  func getWeatherBy(cityName: String) {
    let urlString = "\(baseUrl)\(apiKey)\(units)&q=\(cityName)"
    fetch(urlString)
  }
  
  func getWeatherBy(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(baseUrl)\(apiKey)\(units)&lat=\(latitude)&lon=\(longitude)"
    fetch(urlString)
  }
  
  func fetch(_ stringUrl: String) {
    // 1 - Create a URL
    if let URI = URL(string: stringUrl) {
      // 2 - Create a URLSession
      let session = URLSession(configuration: .default)
      // 3 - Give the URLSession a task
      let task = session.dataTask(with: URI) { (data: Data?, response: URLResponse?, error: Error?) in
        if error != nil {
          self.delegate?.didEndWithError(error!)
          return
        }
        
        if let safeData = data {
          if let weather = self.parseJson(safeData) {
            self.delegate?.didUpdateWeather(self, weather)
          }
        }
      }
      // 4 - Run the task
      task.resume()
    }
  }
  
  func parseJson(_ data: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: data)
      let id = decodedData.weather[0].id
      let city = decodedData.name
      let temp = decodedData.main.temp
      
      return WeatherModel(conditionId: id, cityName: city, temperature: temp)
    } catch {
      self.delegate?.didEndWithError(error)
      return nil
    }
  }
}
