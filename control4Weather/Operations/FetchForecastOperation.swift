//
//  FetchForecastOperation.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

class FetchForecastOperation: AsyncNetworkOperation {
  
  var weather = [Weather]()
  
  fileprivate var loopCount = 0
  fileprivate lazy var maxLoopCount: Int = { return self.weather.count }()
  fileprivate var results = [Forecast]()
  
  fileprivate lazy var syncQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  override func main() {
    guard assignWeatherFromDependency() else { self.state = .finished; return }
    do {
      try weather.forEach{ try assignForecastToWeather(weather: $0) }
    } catch {
      if let error = error as? ErrorMessageCapable { print(error.message) }
    }
  }
  
}

extension FetchForecastOperation {
  
  fileprivate func assignForecastToWeather(weather: Weather) throws {
    let request = OpenWeatherMapRouter.dailyForecast(id: weather.city.id).asURLRequest()
    let _ = NetworkCaller.sharedInstance.getData(request: request) {
      [weak self] data, error in
      guard let data = data else { self?.state = .finished; return }
      
      FetchForecastOperation.workQueue.addOperation{
  
        self?.syncQueue.addOperation { [weak self] in
          do {
            if let forecast = try self?.parseJSON(data: data, weather: weather) {
              self?.results.append(forecast)
            }
          } catch {
            if let error = error as? ErrorMessageCapable { print(error.message) }
            self?.state = .finished
          }
          self?.syncLoopCount()
        }
      }
    }
  }
  
  fileprivate func assignWeatherFromDependency() -> Bool {
    guard weather.isEmpty else { return true }
    guard let dependencyWeatherProfider = dependencies
      .filter({ $0 is WeatherProvider })
      .first as? WeatherProvider else { return false }
    
    if let dependencyWeatherArray = dependencyWeatherProfider.weather {
      weather = dependencyWeatherArray
    }
    return true
  }
  
  fileprivate func parseJSON(data: Data, weather: Weather) throws -> Forecast {
    let jsonParser = JSONParser()
    let result = jsonParser.parseJSON(data)
   
    guard
      let dic = result.0 as? Dictionary<String, Any>,
      let array = dic["list"] as? [Dictionary<String, Any>],
      let temp = array[0]["temp"] as? Dictionary<String, Any>,
      let min = temp["min"] as? Float,
      let max = temp["max"] as? Float
      else { throw NetworkError.jsonParsing }
    
    return Forecast(id: weather.city.id, low: min, high: max)
  }
  
  fileprivate func syncLoopCount() {
    loopCount = min(loopCount + 1, maxLoopCount)
    
    if loopCount >= maxLoopCount {
      self.state = .finished
    }
  }
}

public protocol ForecastProvider {
  var forecasts: [Forecast]? { get }
}

extension FetchForecastOperation: ForecastProvider {
  public var forecasts: [Forecast]? { return self.results }
}

