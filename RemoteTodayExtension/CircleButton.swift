//
//  CircleButton.swift
//  Remote
//
//  Created by Michaël Villar on 3/22/16.
//  Copyright © 2016 michaelvillar. All rights reserved.
//

import Cocoa

class CircleButton: NSButton {

  var imageView: NSImageView!
  var key: String = ""
  var mainColor: NSColor = NSColor.whiteColor()

  init(frame: CGRect, key: String, color: NSColor?, image: NSImage?) {
    super.init(frame: frame)
    
    self.title = ""
    self.mainColor = color ?? NSColor.whiteColor()
    self.key = key
    
    if let aCell = self.cell as? CircleButtonCell {
      aCell.mainColor = self.mainColor
      aCell.currentColor = self.mainColor
    }
    
    imageView = NSImageView(frame: self.bounds)
    imageView.image = image
    self.addSubview(imageView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  static override func cellClass() -> AnyClass {
    return CircleButtonCell.self
  }
}

class CircleButtonCell : NSButtonCell {
  var mainColor: NSColor = NSColor.whiteColor()
  var currentColor: NSColor = NSColor.whiteColor()
  
  override func highlight(flag: Bool, withFrame cellFrame: NSRect, inView controlView: NSView) {
    if flag {
      var hue:CGFloat = 0
      var saturation:CGFloat = 0
      var brightness:CGFloat = 0
      var alpha:CGFloat = 0
      
      if let color = mainColor.colorUsingColorSpace(NSColorSpace.deviceRGBColorSpace()) {
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.currentColor = NSColor(hue: hue, saturation: min(1, saturation * 1.1), brightness: min(1, brightness * 1.3), alpha: alpha)
      }
    } else {
      self.currentColor = self.mainColor
    }
    
    super.highlight(flag, withFrame: cellFrame, inView: controlView)
  }
  
  override func drawWithFrame(frame: NSRect, inView controlView: NSView) {
    NSColor.clearColor().setFill()
    NSBezierPath(rect: frame).fill()
    self.currentColor.setFill()
    NSBezierPath(ovalInRect: frame).fill()
  }
}