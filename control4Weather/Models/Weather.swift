//
//  Weather.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

public struct Weather {
  var city: City
  let currentTemperature: Float
  let dateInfo: WeatherDate
  let description: WeatherDescription
  var forecast: Forecast?
  let humidity: Float
  let pressure: Float
  
  var icon: Icon {
    return Icon(cityId: city.id, fileName: description.iconFileName)
  }
  
  init(city: City, currentTemperature: Float, dateInfo: WeatherDate, description: WeatherDescription, humidity: Float, pressure: Float) {
    self.city = city
    self.currentTemperature = currentTemperature
    self.dateInfo = dateInfo
    self.description = description
    self.humidity = humidity
    self.pressure = pressure
  }
}
