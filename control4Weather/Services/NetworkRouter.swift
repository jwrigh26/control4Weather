//
//  NetworkRouter.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

public enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
}

public protocol URLRequestConvertible {
  func asURLRequest() -> URLRequest
}

public enum OpenWeatherMapRouter: URLRequestConvertible {
  
  static let WeatherBaseURL: URL = URL(string: "http://api.openweathermap.org")!
  static let IconBaseURL: URL = URL(string: "http://openweathermap.org")!
  static let APIKey = "da65fafb6cb9242168b7724fb5ab75e7"
  
  case bulkWeatherConditions(ids: [String])
  case dailyForecast(id: String)
  case weatherConditions(id: String)
  case weatherIcon(fileName: String)
  
  public func asURLRequest() -> URLRequest {
    let (httpMethod, baseURL, path, params): (String, URL, String, [String : String]) = {
      
      var baseURL = OpenWeatherMapRouter.WeatherBaseURL
      let httpMethod = HttpMethod.get.rawValue
      var params: [String : String] = ["APPID" : OpenWeatherMapRouter.APIKey, "units" : "imperial"]
      var path = ""
      
      switch self {
      case .bulkWeatherConditions(let ids):
        var group = ids.reduce("") { str, id in "\(str),\(id)"}
        group.remove(at: group.startIndex)
        params["id"] = group
        path = "data/2.5/group"
        
      case .dailyForecast(let id):
        params["id"] = id
        params["cnt"] = "1"
        path = "data/2.5/forecast/daily"
        
      case .weatherConditions(let id):
        params["id"] = id
        path = "data/2.5/weather"
        
      case .weatherIcon(let fileName):
        baseURL = OpenWeatherMapRouter.IconBaseURL
        params = [:]
        path = "img/w/\(fileName).png"
      }
      
      return (httpMethod, baseURL, path, params)
    }()
    
    let relativeURL = URL(string: path, relativeTo: baseURL)
    
    var components = URLComponents(url: relativeURL!, resolvingAgainstBaseURL: true)
    components?.queryItems = params.flatMap{ URLQueryItem(name: $0.key, value: $0.value)}
    
    var request = URLRequest(url: components!.url!)
    request.httpMethod = httpMethod
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }
}

public enum ApiaryRouter: URLRequestConvertible {
  
  static let BaseUrl: URL = URL(string: "https://private-172408-cities9.apiary-mock.com")!
  
  case cities
  
  public func asURLRequest() -> URLRequest {
    
    let(httpMethod, baseURL, path): (String, URL, String) = {
      guard case .cities = self else { fatalError("No other routes have been defined but cities!") }
      return (HttpMethod.get.rawValue, ApiaryRouter.BaseUrl, "cities")
    }()
    
    let relativeUrl = URL(string: path, relativeTo: baseURL)!
    let components: URLComponents = URLComponents(url: relativeUrl, resolvingAgainstBaseURL: true)!
    var urlRequest = URLRequest(url: components.url!)
    urlRequest.httpMethod = httpMethod
    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return urlRequest
  }
}
