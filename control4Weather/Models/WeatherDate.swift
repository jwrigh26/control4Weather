//
//  WeatherDate.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

struct WeatherDate {
  private let todayFormat = "EEEE"
  private let timeFormat = "h:mm a"
  private let _sunriseTimeInterval: Int
  private let _sunsetTimeInterval: Int
  private let _timeInterval: Int
  
  var dateFormatter: DateFormatter = DateFormatter()
  
  var date: Date { return date(fromTime: _timeInterval) }
  var today: String { return self.format(withTime: _timeInterval, andFormat: todayFormat) }
  var sunrise: String { return self.format(withTime: _sunsetTimeInterval, andFormat: timeFormat) }
  var sunset: String { return self.format(withTime: _sunsetTimeInterval, andFormat: timeFormat) }
  
  
  init(date: Int, sunrise: Int, sunset: Int) {
    self._timeInterval = date
    self._sunriseTimeInterval = sunrise
    self._sunsetTimeInterval = sunset
  }
  
  private func date(fromTime time: Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(time))
  }
  
  private func format(withTime time: Int, andFormat format: String) -> String {
    let date = self.date(fromTime: time)
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
    
  }
}
