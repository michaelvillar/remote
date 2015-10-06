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

  init(frame: CGRect, key: String, color: UIColor, image: UIImage?) {
    super.init(frame: frame)
    
    self.mainColor = color
    self.key = key
    self.backgroundColor = self.mainColor
    self.layer.cornerRadius = frame.size.width / 2
    
    imageView = UIImageView(image: image)
    imageView.frame = self.bounds
    self.addSubview(imageView)
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
}
