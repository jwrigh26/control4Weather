//
//  FetchWeatherOperation.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

class FetchWeatherOperation: AsyncNetworkOperation {
  
  var cities = [City]()
  var results = [Weather]()
  
  fileprivate var loopCount = 0
  fileprivate lazy var maxLoopCount: Int = { return self.cities.count }()
  
  fileprivate lazy var syncQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  override open func main() {
    guard assignCitiesFromDependency() else { self.state = .finished; return }
    let sortedCities = cities.sorted{ $0.0.name < $0.1.name }
    do {
      try sortedCities.forEach{ try assignWeatherToCity(city: $0) }
    }catch {
      if let error = error as? ErrorMessageCapable { print(error.message) }
    }
  }
}

extension FetchWeatherOperation {
  
  fileprivate func assignWeatherToCity(city: City) throws {
    let request =  OpenWeatherMapRouter.weatherConditions(id: city.id).asURLRequest()
    let _ = NetworkCaller.sharedInstance.getData(request: request) {
      [weak self] data, error in
      guard let data = data else { self?.state = .finished; return }
      
      FetchWeatherOperation.workQueue.addOperation {
        
        self?.syncQueue.addOperation { [weak self] in
          do {
            if let weather = try self?.parseJSON(data: data, city: city) {
              self?.results.append(weather)
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
  
  fileprivate func parseJSON(data: Data, city: City) throws -> Weather {
    let jsonParser = JSONParser()
    let result = jsonParser.parseJSON(data)
    
    guard let dic = result.0 as? Dictionary<String, Any>
      else { throw NetworkError.jsonParsing }
    return try parseWeatherFromJSONDictionary(dictionary: dic, city: city)
  }
  
  fileprivate func syncLoopCount() {
    loopCount = min(loopCount + 1, maxLoopCount)
    
    if loopCount >= maxLoopCount {
      self.state = .finished
    }
  }
}

extension FetchWeatherOperation {
  
  func assignCitiesFromDependency() -> Bool {
    guard cities.isEmpty else { return true } // We already have cities so no need
    guard let dependencyCityProvider = dependencies
      .filter({ $0 is CityProvider})
      .first as? CityProvider else { return false }
    if let depdependencyCities = dependencyCityProvider.cities {
      cities = depdependencyCities
    }
    return true
  }
  
  func parseWeatherFromJSONDictionary(dictionary: Dictionary<String, Any>, city: City) throws -> Weather {
    guard
      let array = dictionary["weather"] as? [Any],
      let desc = array[0] as? Dictionary<String, Any>,
      let icon = desc["icon"] as? String,
      let word = desc["main"] as? String,
      let simpleDesc = desc["description"] as? String
      else { throw NetworkError.jsonParsing }
    
    let weatherDescription = WeatherDescription(iconFileName: icon, oneWordDescription: word, simpleDescription: simpleDesc)
    
    guard
      let date = dictionary["dt"] as? Int,
      let sys = dictionary["sys"] as? Dictionary<String, Any>,
      let sunrise = sys["sunrise"] as? Int,
      let sunset = sys["sunset"] as? Int
      else { throw NetworkError.jsonParsing }
    
    let dateInfo = WeatherDate(date: date, sunrise: sunrise, sunset: sunset)
    
    guard
      let main = dictionary["main"] as? Dictionary<String, Any>,
      let temp = main["temp"] as? Float,
      let humidity = main["humidity"] as? Float,
      let pressure = main["pressure"] as? Float
      else { throw NetworkError.jsonParsing }
    
    return Weather(city: city, currentTemperature: temp, dateInfo: dateInfo, description: weatherDescription, humidity: humidity, pressure: pressure)
  }
  
  func sortListOfWeather(array: [Dictionary<String, Any>]) throws -> [Dictionary<String, Any>] {
    guard let _ = array[0]["name"] as? String else { throw NetworkError.jsonParsing }
    return array.sorted{ ($0.0["name"] as! String) < ($0.1["name"] as! String) }
  }
}

public protocol WeatherProvider {
  var weather: [Weather]? { get }
}

extension FetchWeatherOperation: WeatherProvider {
  public var weather: [Weather]? { return self.results }
}
