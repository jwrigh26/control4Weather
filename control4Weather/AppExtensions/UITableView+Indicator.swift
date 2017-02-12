//
//  UITableView+Indicator.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

extension UITableView {
  
  func addIndicator(_ style: UIActivityIndicatorViewStyle) -> UIActivityIndicatorView? {
    guard let indicator = createIndicator(style) else { return nil}
    addSubview(indicator)
    layoutIndicator(indicator)
    return indicator
  }
  
  fileprivate func createIndicator(_ style: UIActivityIndicatorViewStyle) -> UIActivityIndicatorView? {
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: style)
    indicator.alpha = 1.0
    indicator.hidesWhenStopped = true
    indicator.sizeToFit()
    return indicator
  }
  
  fileprivate func layoutIndicator(_ indicator: UIActivityIndicatorView?) {
    guard let indicator = indicator, let parent = indicator.superview else { return }
    indicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: parent.layoutMarginsGuide.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: parent.layoutMarginsGuide.centerYAnchor)
      ])
  }
  
}
