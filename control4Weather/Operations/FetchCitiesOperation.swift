//
//  FetchCitiesOperation.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

class FetchCitiesOperation: AsyncNetworkOperation {
  
  fileprivate var results = [City]()
  
  override func main() {
    let request = ApiaryRouter.cities.asURLRequest()
    let _ = NetworkCaller.sharedInstance.getData(request: request) {
      [weak self] data, error in
      guard let data = data else { self?.state = .finished; return }
      self?.assignCitiesFromData(data: data)
    }
  }
}

extension FetchCitiesOperation {
  
  fileprivate func assignCitiesFromData(data: Data){
    FetchCitiesOperation.workQueue.addOperation { [weak self] in
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
  
  fileprivate func parseJSON(data: Data) throws -> [City] {
    let jsonParser = JSONParser()
    let result = jsonParser.parseJSON(data)
   guard let array = result.0 as? [Dictionary<String, Any>] else {
       throw NetworkError.jsonParsing
    }
    
    let cities: [City] = try array.flatMap {
      guard
        let coord = $0["coord"] as? Dictionary<String, Double>,
        let country = $0["country"] as? String,
        let id = $0["id"] as? Int,
        let name = $0["city"] as? String,
        let state = $0["state"] as? String,
        let stateAbbreviation = $0["state-abbreviation"] as? String
        else { throw NetworkError.jsonParsing }
      
      let lat = coord["lat"] ?? 0.0
      let lng = coord["lon"] ?? 0.0
      
      let location = Location(lattitude: lat, longitude: lng)
      return City(country: country, id: id, location: location, name: name, state: state, stateAbbreviation: stateAbbreviation)
    }
    
    return cities
  }
}


protocol CityProvider {
  var cities: [City]? { get }
}

extension FetchCitiesOperation: CityProvider {
  var cities: [City]? { return self.results }
}

