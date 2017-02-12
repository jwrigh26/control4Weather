//
//  RoundedView.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
  
  var shadowView: UIView = UIView()
  var gradientView: UIView = UIView()
  var layerGradient = CAGradientLayer()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  func setup() {
    backgroundColor = UIColor.clear
    styleShadow()
    styleGradient()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    shadowView.frame = self.frame.insetBy(dx: 1.0, dy: 1.0)
    
    let shapeLayer = CAShapeLayer()
    
    shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30.0, height: 30.0)).cgPath
    layer.mask = shapeLayer
    shadowView.layer.cornerRadius = 30.0
    
    layerGradient.frame = CGRect(x: 0, y: frame.origin.y, width: bounds.width, height: bounds.height + 100)
    layerGradient.cornerRadius = 30.0
    
  }
  
  fileprivate func styleShadow() {
    shadowView.layer.shadowRadius = 4.0 // how wide to spread out
    shadowView.layer.shadowOpacity = 0.3 // 1 - 0
    shadowView.layer.shadowOffset = CGSize(width: 0, height: -4)
    shadowView.layer.masksToBounds = false
    shadowView.layer.backgroundColor = UIColor.black.cgColor
    
    if let parent = self.superview {
      parent.insertSubview(shadowView, belowSubview: self)
    }
  }
  
  fileprivate func styleGradient() {
    layerGradient.colors = [AppColor.medBlue.color.cgColor, AppColor.darkBlue.color.cgColor]
    layerGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
    layerGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientView.layer.addSublayer(layerGradient)
    if let parent = self.superview {
      parent.insertSubview(gradientView, belowSubview: self)
    }
    
  }
}

