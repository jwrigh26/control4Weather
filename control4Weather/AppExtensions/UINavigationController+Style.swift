//
//  UINavigationController+Style.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

extension UINavigationController {
  
  func setAppStyle(){
    self.navigationBar.barStyle = UIBarStyle.black
    self.navigationBar.isTranslucent = true
    self.navigationBar.barTintColor = AppColor.darkBlue.color
    self.navigationBar.tintColor = AppColor.lightBlue.color
  }
}
