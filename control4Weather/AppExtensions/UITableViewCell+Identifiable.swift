//
//  UITableViewCell+Identifiable.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

protocol UITableViewCellIdentifiable {
  static var cellIdentifier: String { get }
}

extension UITableViewCellIdentifiable where Self: UITableViewCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell : UITableViewCellIdentifiable { }
