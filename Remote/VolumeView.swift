//
//  VolumeView.swift
//  Remote
//
//  Created by Michaël Villar on 8/5/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import UIKit

class VolumeView: UIView {

  var startAngle:CGFloat = 0
  var endAngle:CGFloat = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clearColor()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    let center = CGPointMake(self.frame.width / 2, self.frame.height / 2)
    
    var angle1 = startAngle
    var angle2 = endAngle
    var color = UIColor(red: 0.0, green: 0.4481, blue: 1.0, alpha: 0.3)
    if angle1 > angle2 {
      angle1 = endAngle
      angle2 = startAngle
      color = UIColor(red: 0.9922, green: 0.2937, blue: 0.0454, alpha: 0.3)
    }
    
    var width:CGFloat = 10
    color.setStroke()
    
    while angle2 - angle1 > 0 {
      let path = UIBezierPath(arcCenter: center, radius: 115, startAngle: angle1, endAngle: angle2, clockwise:
        true)
      path.lineWidth = width
      path.stroke()
      
      angle2 = angle2 - 2 * CGFloat(Double(M_PI))
      width += 4
    }
  }

}
