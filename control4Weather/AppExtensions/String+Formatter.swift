//
//  String+Formatter.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

extension String {
  
  static func format(forFahrenheit value: Float) -> String {
    return String(format: "%2d°", Int(value)) //shift-option-8 or option-k for degree symbol
  }
  
  static func format(forPercent value: Float) -> String {
    return String(format: "%2d%%", Int(value))
  }
  
  static func format(forHPA value: Float) -> String {
    return String(format: "%2d in hPa", Int(value))
  }
  
}
