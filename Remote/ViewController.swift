//
//  ViewController.swift
//  Remote
//
//  Created by Michaël Villar on 7/25/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  
  private let commands:[String:[IRCommand]]!
  private let sender:IRSender!
  private var volumeDelta:Double = 0
  private var fullVolumeDelta:Double = 0
  private var volumeView:VolumeView = VolumeView()
  private var volumeLabel:UILabel = UILabel()
  private var topArrow:UIImageView = UIImageView()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    
    self.sender = IRSender()
    self.sender.connect("10.0.0.18")

    self.commands = [String:[IRCommand]]()
    self.commands["Power On"] = [
      IRCommand(channel: 1, cmd: "38000,1,69,341,172,21,21,21,65,21,65,21,65,21,21,21,65,21,65,21,65,21,65,21,65,21,65,21,21,21,21,21,21,21,21,21,65,21,65,21,65,21,21,21,21,21,21,21,21,21,21,21,21,21,65,21,65,21,21,21,21,21,21,21,65,21,21,21,21,21,1508,341,85,21,3648"),
      IRCommand(channel: 2, cmd: "38000,1,69,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,1517,341,85,21,3655"),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24")
    ]
    self.commands["Power Off"] = [
      IRCommand(channel: 2, cmd: "38000,1,69,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,21,21,1517,341,85,21,3655"),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,48,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,990,95,24,48,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,990,95,24,48,24,47,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24")
    ]
    self.commands["Volume Up"] = [
      IRCommand(channel: 2, cmd: "38000,1,1,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,64,21,64,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,500")
    ]
    self.commands["Volume Down"] = [
      IRCommand(channel: 2, cmd: "38000,1,1,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,64,21,64,21,21,21,21,21,500"),
    ]
    self.commands["HDMI Apple TV"] = [
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,821,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,821,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,24")
    ]
    self.commands["HDMI Wii"] = [
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,798,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,798,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,24")
    ]
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.blackColor()
    
//    let keys = ["Volume Up", "Volume Down", "HDMI Apple TV", "HDMI Wii", "Power Off"];
//    for(var i=0;i<keys.count;i++) {
//      let key = keys[i]
//      let button = UIButton(frame: CGRectMake(10, 20 + CGFloat(Double(i * 50)), self.view.bounds.width - 20, 50))
//      button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
//      button.setTitle(key, forState: UIControlState.Normal)
//      button.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside)
//      self.view.addSubview(button)
//    }
    
//    volumeLabel.textColor = UIColor.blackColor()
//    volumeLabel.textAlignment = .Center
//    volumeLabel.frame = CGRectMake(0, 100, self.view.bounds.width, 50)
//    volumeLabel.userInteractionEnabled = false
//    self.view.addSubview(volumeLabel)
//    
    
    volumeView.frame = self.view.bounds
    volumeView.userInteractionEnabled = false
    self.view.addSubview(volumeView)
    
    topArrow.image = UIImage(named: "arrow")
    topArrow.frame = CGRectMake(self.view.bounds.width / 2 - 14, self.view.bounds.height / 2 - 92, 28, 12)
    self.view.addSubview(topArrow)
    
    let circularRecognizer = CircularGestureRecognizer(target: self, action: "handleVolume:")
    circularRecognizer.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2)
    circularRecognizer.delegate = self
    
    let panRecognizer = PanFromCenterGestureRecognizer(target: self, action: "handlePan:")
    panRecognizer.center = circularRecognizer.center
    panRecognizer.radius = self.view.frame.width / 4
    panRecognizer.delegate = self

    self.view.addGestureRecognizer(circularRecognizer)
    self.view.addGestureRecognizer(panRecognizer)
  }
  
  func handleButton(button:UIButton) {
    if let key = button.titleForState(.Normal) {
      if key == "HDMI Apple TV" || key == "HDMI Wii" {
        sendCommand("Power On")
      }
      sendCommand(key)
    }
  }
  
  func handleVolume(recognizer:CircularGestureRecognizer) {
    volumeView.startAngle = recognizer.startAngle + CGFloat(Double(M_PI))
    volumeView.endAngle = recognizer.currentAngle + CGFloat(Double(M_PI))
    volumeView.setNeedsDisplay()
    
    if recognizer.state == UIGestureRecognizerState.Began {
      fullVolumeDelta = 0
    }
    else if recognizer.state == UIGestureRecognizerState.Changed {
      volumeDelta += Double(recognizer.rotationDelta)
      fullVolumeDelta += Double(recognizer.rotationDelta)
      while(volumeDelta >= 1) {
        sendCommand("Volume Up")
        volumeDelta -= 1
      }
      while(volumeDelta < -1) {
        sendCommand("Volume Down")
        volumeDelta += 1
      }
      volumeLabel.text = NSString(format: "%i", NSNumber(double: fullVolumeDelta).integerValue) as String
    }
    else if recognizer.state == UIGestureRecognizerState.Ended {
      volumeLabel.text = ""
    }
  }
  
  func handlePan(recognizer:PanFromCenterGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.Began {
      println("began")
    }
    else if recognizer.state == UIGestureRecognizerState.Changed {
      
    }
    else if recognizer.state == UIGestureRecognizerState.Ended {
      println("ended")
    }
  }
  
  private func sendCommand(key:String) {
    if let cmds = self.commands[key] {
      for cmd in cmds {
        sender.send(cmd)
      }
    }
  }

}

