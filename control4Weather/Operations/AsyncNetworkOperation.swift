//
//  AsyncNetworkOperation.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit



public protocol NetworkOperationable {
  func startStatusBarIndicator()
  func stopStatusBarIndicator()
}

extension NetworkOperationable {
  
  public func startStatusBarIndicator(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  public func stopStatusBarIndicator(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}

open class AsyncNetworkOperation: AsyncOperation, NetworkOperationable { }

extension AsyncNetworkOperation {

  override open var isExecuting: Bool {
    let executing = state == .executing
    if executing { startStatusBarIndicator() }
    return executing
  }

  override open var isFinished: Bool {
    let finished = state == .finished
    if finished { stopStatusBarIndicator() }
    return finished
  }

}
