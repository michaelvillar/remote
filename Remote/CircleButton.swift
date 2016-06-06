//
//  CircleButton.swift
//  Remote
//
//  Created by Michaël Villar on 10/5/15.
//  Copyright © 2015 michaelvillar. All rights reserved.
//

import UIKit

class CircleButton: UIControl {
  
  var imageView: UIImageView!
  var key: String = ""
  var mainColor: UIColor = UIColor.whiteColor()

  init(frame: CGRect, key: String, color: UIColor?, image: UIImage?) {
    super.init(frame: frame)
    
    self.mainColor = color ?? UIColor.whiteColor()
    self.key = key
    self.backgroundColor = self.mainColor
    self.layer.cornerRadius = frame.size.width / 2
    self.clipsToBounds = false
    
    imageView = UIImageView(image: image)
    imageView.frame = self.bounds
    self.addSubview(imageView)
    
    self.addTarget(self, action: #selector(handleTouch), forControlEvents: UIControlEvents.TouchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var highlighted: Bool {
    didSet {
      if highlighted {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        
        mainColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.backgroundColor = UIColor(hue: hue, saturation: min(1, saturation * 1.1), brightness: min(1, brightness * 1.3), alpha: alpha)
      } else {
        self.backgroundColor = self.mainColor
      }
    }
  }
  
  func handleTouch(button:UIButton) {
    let margin:CGFloat = 20
    let circle = CircleHighlight(frame: CGRectInset(self.bounds, -margin, -margin), color: self.mainColor)
    let scale:CGFloat = self.bounds.width / (self.bounds.width + margin)
    circle.transform = CGAffineTransformMakeScale(scale, scale)
    circle.userInteractionEnabled = false
    self.addSubview(circle)
    
    UIView.animateWithDuration(0.3,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: {
        circle.transform = CGAffineTransformIdentity
    }) { (bool) -> Void in
    }
    
    UIView.animateWithDuration(0.3,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        circle.alpha = 0.0
      }) { (bool) -> Void in
        circle.removeFromSuperview()
    }
  }
}

class CircleHighlight: UIView {
  
  var color: UIColor = UIColor.whiteColor()
  
  init(frame: CGRect, color: UIColor) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clearColor()
    self.color = color
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    let lineWidth:CGFloat = 2.0
    let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, lineWidth, lineWidth))
    path.lineWidth = lineWidth
    self.color.setStroke()
    path.stroke()
  }
  
}
