//
//  UIColor+HexColor.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Bad red component")
    assert(green >= 0 && green <= 255, "Bad green component")
    assert(blue >= 0 && blue <= 255, "Bad blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(hex:Int) {
    self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
  }
}
