//
//  CircleView.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
  
  let circleLayer = CAShapeLayer()
  
  
  @IBInspectable var fillColor: UIColor = AppColor.lightBlue.color {
    didSet {
      configure()
    }
  }
  

  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  func setup() {
    
    circleLayer.contentsGravity = kCAGravityResizeAspectFill
    layer.addSublayer(circleLayer)
  }
  
  func configure() {
    circleLayer.fillColor = fillColor.cgColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let h = bounds.height
    circleLayer.frame = CGRect(x: bounds.midX - h/2, y: bounds.midY - h/2, width: h, height: h)
    
    let mask = CAShapeLayer()
    mask.path = UIBezierPath(ovalIn: circleLayer.bounds).cgPath
    circleLayer.mask = mask
    circleLayer.path = mask.path
  }
}
