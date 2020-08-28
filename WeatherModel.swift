//
//  WeatherModel.swift
//  Clima
//
//  Created by Manuel Hernández on 22/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
  let conditionId: Int
  let cityName: String
  let temperature: Double
  
  var tempFloat: String {
    return String(format: "%.1f", temperature)
  }
  
  var conditionName: String {
    switch conditionId {
    case 200 ... 232:
      return "cloud.bolt"
    case 300 ... 321:
      return "cloud.drizzle"
    case 500 ... 531:
      return "cloud.rain"
    case 600 ... 622:
      return "cloud.snow"
    case 700 ... 771:
      return "cloud.fog"
    case 781:
      return "tornado"
    case 800:
      return "sun.max"
    case 801 ... 804:
      return "smoke"
    default:
      return "cloud.sun"
    }
  }
}
