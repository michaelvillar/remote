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

  init(frame: CGRect, key: String, color: UIColor, image: UIImage?) {
    super.init(frame: frame)
    
    self.key = key
    self.backgroundColor = color
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
      alpha = highlighted ? 0.6 : 1.0
    }
  }
}
