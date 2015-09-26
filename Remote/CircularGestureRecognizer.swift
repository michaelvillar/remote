//
//  CircularGestureRecognizer.swift
//  Remote
//
//  Created by Michaël Villar on 8/5/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import Foundation

private let CG_PI = CGFloat(Double(M_PI))

class CircularGestureRecognizer: UIGestureRecognizer {
  
  var rotation:CGFloat = 0
  var rotationDelta:CGFloat = 0
  var center:CGPoint = CGPointZero
  var startAngle:CGFloat = 0
  var currentAngle:CGFloat = 0
  
  override func touchesBegan(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    super.touchesBegan(touches, withEvent: event)

    if touches.count > 1 {
      self.state = UIGestureRecognizerState.Failed
      return
    }
    
    if let touch:UITouch = touches.first as? UITouch {
      let point = touch.locationInView(self.view)
      self.startAngle = self.angleBetweenPoints(a: point, b:center)
      self.currentAngle = self.startAngle
    }
  }
  
  override func touchesMoved(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    super.touchesMoved(touches, withEvent: event)
    
    if self.state == UIGestureRecognizerState.Possible {
      self.state = UIGestureRecognizerState.Began
    } else {
      self.state = UIGestureRecognizerState.Changed
    }
    
    if let touch:UITouch = touches.first as? UITouch {
      let lastPoint = touch.previousLocationInView(self.view)
      let newPoint = touch.locationInView(self.view)
      
      let lastRadius = self.distanceBetweenPoints(a: lastPoint, b: center)
      let newRadius = self.distanceBetweenPoints(a: newPoint, b: center)
      
      let lastAngle = self.angleBetweenPoints(a: lastPoint, b:center)
      let newAngle = self.angleBetweenPoints(a: newPoint, b:center)
      var diff = newAngle - lastAngle
      if diff > CG_PI {
        diff -= 2 * CG_PI
      } else if diff < -CG_PI {
        diff += 2 * CG_PI
      }

      self.currentAngle += diff
      self.rotation = self.currentAngle - self.startAngle
      self.rotationDelta = diff
    }
  }
  
  override func touchesEnded(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    super.touchesEnded(touches, withEvent: event)
    
    self.rotation = 0
    self.rotationDelta = 0
    self.currentAngle = 0
    self.startAngle = 0
    
    if self.state == UIGestureRecognizerState.Changed {
      self.state = UIGestureRecognizerState.Ended
    } else {
      self.state = UIGestureRecognizerState.Failed
    }
  }
  
  override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    super.touchesCancelled(touches, withEvent: event)
  }
  
  private func angleBetweenPoints(#a:CGPoint, b:CGPoint) -> CGFloat {
    var angle =  atan2(b.y - a.y, b.x - a.x)
    if angle < 0 {
      angle = 2 * CG_PI + angle
    }
    return angle
  }
  
  private func distanceBetweenPoints(#a:CGPoint, b:CGPoint) -> CGFloat {
    let dx = (b.x-a.x)
    let dy = (b.y-a.y)
    return sqrt(dx*dx + dy*dy)
  }
  
}