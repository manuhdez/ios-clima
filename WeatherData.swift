//
//  WeatherData.swift
//  Clima
//
//  Created by Manuel Hernández on 22/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
  let name: String
  let main: Main
  let weather: [WeatherItem]
}

struct Main: Decodable {
  let temp: Double
  let humidity: Int
}

struct WeatherItem: Decodable {
  let id: Int
  let main: String
  let description: String
}
