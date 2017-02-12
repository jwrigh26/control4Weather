//
//  AppDelegate+Style.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

extension AppDelegate {
  
}

enum AppColor: Int {
  
  case darkBlue = 0x001125
  case medBlue = 0x45758D
  case lightBlue = 0xA3CCD8
  case highlightSalmon = 0xA73737
  case darkBrown = 0x0B0C0E
  
  
  var color: UIColor {
    return UIColor(hex: self.rawValue)
  }
  
}

public protocol ErrorMessageCapable {
  var message: String { get }
  func getMessage() -> String
}

extension ErrorMessageCapable {
  var message: String {
    return getMessage()
  }
}
