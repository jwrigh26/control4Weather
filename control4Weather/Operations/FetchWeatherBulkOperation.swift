//
//  FetchWeatherOperation.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

class FetchWeatherBulkOperation: FetchWeatherOperation {
  
  
  override func main() {
    guard assignCitiesFromDependency() else { state = .finished; return }
    let ids = cities.map{ $0.id }
    let request = OpenWeatherMapRouter.bulkWeatherConditions(ids: ids).asURLRequest()
    let _ = NetworkCaller.sharedInstance.getData(request: request) {
      [weak self] data, error in
      guard let data = data else { self?.state = .finished; return }
      self?.assignWeatherFromData(data: data)
    }
  }
}

extension FetchWeatherBulkOperation {
  
  fileprivate func assignWeatherFromData(data: Data) {
    FetchWeatherBulkOperation.workQueue.addOperation { [weak self] in
      do {
        if let results = try self?.parseJSON(data: data) {
          self?.results = results
        }
        self?.state = .finished
      } catch {
        // TODO: Add proper error handling here.
        if let error = error as? ErrorMessageCapable { print(error.message) }
        self?.state = .finished
      }
    }
  }
  
  fileprivate func parseJSON(data: Data) throws -> [Weather] {
    let jsonParser = JSONParser()
    let result = jsonParser.parseJSON(data)
    
    guard
      let dic = result.0 as? Dictionary<String, Any>,
      let array = dic["list"] as? [Dictionary<String, Any>] else {
        throw NetworkError.jsonParsing
    }
    
    // Sort alphabetically
    let sortedArray = try sortListOfWeather(array: array)
    
    // Make a tuple array that has both the weather dic and city associated with it
    let tupleArray: [(Dictionary<String, Any>, City)] = {
      
      let array:[(Dictionary<String, Any>, City)]  = sortedArray.map{ value in
        // We force unwrap the optional because if "name" was not a string it would have failed at sortListOfWeather:
        let city = cities.filter({ $0.name == (value["name"] as! String) }).first
        return (value, city!)
      }
      
      return array
    }()
    
    let weatherArray: [Weather] = try tupleArray.map{ return try parseWeatherFromJSONDictionary(dictionary: $0.0, city: $0.1) }
    return weatherArray
  }
}
