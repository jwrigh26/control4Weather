//
//  NetworkCaller.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

enum NetworkError: String, Error, ErrorMessageCapable {
  case badNewsBears = "Oops, something bad happened."
  case urlRelated = "Oops, with the URL request."
  case downloadFail = "Oops, unable to download content from URL."
  case jsonParsing = "Oops, unable to parse the JSON file."
  
  func getMessage() -> String {
    return self.rawValue
  }
}

typealias NetworkCallerDataResult = (Data?, Error?) -> Void
typealias NetworkCallerImageResult = (UIImage? , Error?) -> Void

class NetworkCaller {
  
  fileprivate var session: URLSession
  
  let jsonParser = JSONParser()
  static let sharedInstance = NetworkCaller()
  
  init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 2.0
    session = URLSession(configuration: configuration)
  }
  
  func getData(request: URLRequest, callback: @escaping NetworkCallerDataResult) -> URLSessionDataTask {
    let task = session.dataTask(with: request) { data, response, error in
      guard let data = data else {
        // TODO: Add proper error handling here.
        if let error = error as? ErrorMessageCapable { print(error.message) }
        OperationQueue.main.addOperation { callback(nil, error) }
        return
      }
      OperationQueue.main.addOperation{ callback(data, nil) }
    }
    task.resume()
    return task
  }
  
  func getImage(request: URLRequest, callback: @escaping NetworkCallerImageResult) -> URLSessionDownloadTask {
    let task = session.downloadTask(with: request) { file, response, error in
      guard let file = file else {
        // TODO: Add proper error handling here.
        if let error = error as? ErrorMessageCapable { print(error.message) }
        OperationQueue.main.addOperation { callback(nil, error) }
        return
      }
      
      if let data = try? Data(contentsOf: file), let image = UIImage(data: data) {
        OperationQueue.main.addOperation{ callback(image, nil) }
      } else {
        OperationQueue.main.addOperation { callback(nil, NetworkError.downloadFail) }
      }
    }
    task.resume()
    return task
  }
}
