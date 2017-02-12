//
//  Icon.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

public struct Icon {
  var cityId: String
  var fileName: String
}

// MARK: Equatable
func == (lhs: Icon, rhs: Icon) -> Bool {
  return lhs.fileName == rhs.fileName
}


public protocol WeatherIconFetchable: class {
  
  var imageTask: URLSessionDownloadTask? { get set }
  var icon: Icon? { get }
  var weatherImageView: UIImageView! { get }
  func getImageForIcon(fileName file: String?)
}

extension WeatherIconFetchable {
  
  func getImageForIcon(fileName file: String?) {
    guard let file = file else { return }
    let request = OpenWeatherMapRouter.weatherIcon(fileName: file).asURLRequest()
    imageTask = NetworkCaller.sharedInstance.getImage(request: request) {
      [weak self] image, error in
      guard let image = image else { return }
      self?.weatherImageView.image = image
    }
  }
}
