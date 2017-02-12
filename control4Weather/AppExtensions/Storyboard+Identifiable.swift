//
//  Storyboard+Identifiable.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

extension UIStoryboard {
  
  enum Storyboard: String {
    case Main
    case Details
  }
  
  convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
    self.init(name: storyboard.rawValue, bundle: bundle)
  }
  
  class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
  }
  
  func initViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
    let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
    
    guard let viewController = optionalViewController as? T  else {
      fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier) ")
    }
    
    return viewController
  }
  
}

protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}

extension UIViewController : StoryboardIdentifiable { } // Global conformance
