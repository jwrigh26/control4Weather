//
//  UINavigationItem+BackBarButtonItem.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

import UIKit

extension UINavigationItem {
  
  private static var doOnce: () = {
    let originalSelector = #selector(getter: UINavigationItem.backBarButtonItem)
    let swizzledSelector = #selector(UINavigationItem.noTitleBackBarButtonItem)
    
    let originalMethod = class_getInstanceMethod(UINavigationItem.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UINavigationItem.self, swizzledSelector)
    
    let didAddMethod = class_addMethod(UINavigationItem.self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
      class_replaceMethod(UINavigationItem.self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }()
  
  
  open override class func initialize() {
    if self !== UINavigationItem.self { return }
    _ = UINavigationItem.doOnce
  }
  
  
  // MARK: - Method Swizzling
  
  struct AssociatedKeys {
    static var ArrowBackButtonKey = "noTitleArrowBackButtonKey"
  }
  
  func noTitleBackBarButtonItem() -> UIBarButtonItem? {
    
    if let item = self.noTitleBackBarButtonItem() {
      return item
    }
    
    
    if let item = objc_getAssociatedObject(self, &AssociatedKeys.ArrowBackButtonKey) as? UIBarButtonItem {
      return item
    } else {
      let newItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
      objc_setAssociatedObject(self, &AssociatedKeys.ArrowBackButtonKey, newItem as UIBarButtonItem?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return newItem
    }
  }
}
