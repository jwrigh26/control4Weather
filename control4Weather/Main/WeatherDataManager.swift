//
//  WeatherDataManager.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

typealias WeatherDataResult = (_ success: Bool, _ error: Error?) -> Void

enum WeatherError: String, Error, ErrorMessageCapable {
  case badNewsBears = "Oops, something bad happened."
  case bulkCallFailed = "Oops, the bulk call failed. This happens from time to time."
  case noWeather = "Oops, no weather for today."
  
  func getMessage() -> String {
    return self.rawValue
  }
}

class WeatherDataManager {
  
  var userQueue: OperationQueue {
    let queue = OperationQueue()
    queue.qualityOfService = .userInitiated
    return queue
  }
  
  var forecasts: [Forecast]?
  var weather: [Weather]?
  
  func getWeatherByBulkCall(callback: @escaping WeatherDataResult) {
    let queue = userQueue
    let cityOperation = FetchCitiesOperation()
    let weatherBulkOperation = FetchWeatherBulkOperation()
    let forecastOperation = FetchForecastOperation()
    
    weatherBulkOperation.addDependency(cityOperation)
    
    weatherBulkOperation.completionBlock = {
      if let weather = weatherBulkOperation.weather, weather.isEmpty {
        queue.cancelAllOperations()
        OperationQueue.main.addOperation{ callback(false, WeatherError.bulkCallFailed) }
      }
    }
    
    forecastOperation.addDependency(weatherBulkOperation)
    
    forecastOperation.completionBlock = { [weak self] in
      let weather = forecastOperation.weather
      guard let forecasts = forecastOperation.forecasts,
        !weather.isEmpty,
        !forecasts.isEmpty,
        weather.count == forecasts.count else {
          queue.cancelAllOperations()
          OperationQueue.main.addOperation{ callback(false, WeatherError.noWeather) }
          return
      }
      OperationQueue.main.addOperation{
        self?.forecasts = forecasts
        self?.weather = weather
        callback(true, nil)
      }
    }
    
    queue.addOperations([cityOperation, weatherBulkOperation, forecastOperation], waitUntilFinished: false)
  }
  
  func getWeatherByInefficientCall(callback: @escaping WeatherDataResult) {
    let queue = userQueue
    let cityOperation = FetchCitiesOperation()
    let weatherOperation = FetchWeatherOperation()
    let forecastOperation = FetchForecastOperation()
    
    weatherOperation.addDependency(cityOperation)
    forecastOperation.addDependency(weatherOperation)
    
    // TODO: WET code. Come back here to refactor and make it DRY
    forecastOperation.completionBlock = { [weak self] in
      let weather = forecastOperation.weather
      guard let forecasts = forecastOperation.forecasts,
        !weather.isEmpty,
        !forecasts.isEmpty,
        weather.count == forecasts.count else {
          queue.cancelAllOperations()
          OperationQueue.main.addOperation{ callback(false, WeatherError.noWeather) }
          return
      }
      OperationQueue.main.addOperation{
        self?.forecasts = forecasts
        self?.weather = weather
        callback(true, nil)
      }
      print("We had to call the backup. :( Why U NO work bulk call!!!")
    }
    
    queue.addOperations([cityOperation, weatherOperation, forecastOperation], waitUntilFinished: false)
    
  }
}
