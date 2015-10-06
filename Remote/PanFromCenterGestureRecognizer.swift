//
//  PanFromCenterGestureRecognizer.swift
//  Remote
//
//  Created by Michaël Villar on 8/5/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import UIKit

private let CG_PI = CGFloat(Double(M_PI))

class PanFromCenterGestureRecognizer: UIGestureRecognizer {
  
  var center:CGPoint = CGPointZero
  var radius:CGFloat = 0
  var angle:CGFloat = 0
  var distance:CGFloat = 0
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    
    if touches.count > 1 {
      self.state = UIGestureRecognizerState.Failed
      return
    }
    
    if let touch:UITouch = touches.first {
      let point = touch.locationInView(self.view)
      if self.distanceBetweenPoints(a: point, b: center) > radius {
        self.state = UIGestureRecognizerState.Failed
        return
      }
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesMoved(touches, withEvent: event)
    
    if self.state == UIGestureRecognizerState.Possible {
      self.state = UIGestureRecognizerState.Began
    } else {
      self.state = UIGestureRecognizerState.Changed
    }
    
    if let touch:UITouch = touches.first {
      let point = touch.locationInView(self.view)
      self.distance = self.distanceBetweenPoints(a: point, b: center)
      self.angle = self.angleBetweenPoints(a: point, b: center)
      print(abs(angle))
      
      if self.isAroundAngle(abs(angle), aroundAngle: 0) ||
         self.isAroundAngle(abs(angle), aroundAngle: CG_PI * 2) {
        print("left")
      }
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesEnded(touches, withEvent: event)
    
    if self.state == UIGestureRecognizerState.Changed {
      self.state = UIGestureRecognizerState.Ended
    } else {
      self.state = UIGestureRecognizerState.Failed
    }
  }
  
  override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesCancelled(touches, withEvent: event)
  }
  
  private func angleBetweenPoints(a a:CGPoint, b:CGPoint) -> CGFloat {
    var angle =  atan2(b.y - a.y, b.x - a.x)
    if angle < 0 {
      angle = 2 * CG_PI + angle
    }
    return angle
  }
  
  private func distanceBetweenPoints(a a:CGPoint, b:CGPoint) -> CGFloat {
    let dx = (b.x-a.x)
    let dy = (b.y-a.y)
    return sqrt(dx*dx + dy*dy)
  }
  
  private func isAroundAngle(angle:CGFloat, aroundAngle:CGFloat) -> Bool {
    return abs(angle - aroundAngle) < 0.4
  }
}
