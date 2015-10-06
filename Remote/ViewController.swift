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

    self.commands = [String:[IRCommand]]()
    self.commands["power_on"] = [
      IRCommand(channel: 1, cmd: "38000,1,69,341,172,21,21,21,65,21,65,21,65,21,21,21,65,21,65,21,65,21,65,21,65,21,65,21,21,21,21,21,21,21,21,21,65,21,65,21,65,21,21,21,21,21,21,21,21,21,21,21,21,21,65,21,65,21,21,21,21,21,21,21,65,21,21,21,21,21,1508,341,85,21,3648"),
      IRCommand(channel: 2, cmd: "38000,1,69,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,1517,341,85,21,3655"),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24")
    ]
    self.commands["power_off"] = [
      IRCommand(channel: 2, cmd: "38000,1,69,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,21,21,1517,341,85,21,3655"),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,48,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,990,95,24,48,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,990,95,24,48,24,47,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24")
    ]
    self.commands["volume_up"] = [
      IRCommand(channel: 2, cmd: "38000,1,1,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,64,21,64,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,500")
    ]
    self.commands["volume_down"] = [
      IRCommand(channel: 2, cmd: "38000,1,1,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,64,21,64,21,21,21,21,21,500"),
    ]
    self.commands["input_apple"] = [
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,821,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,821,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,24")
    ]
    self.commands["input_wii"] = [
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,798,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,798,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,24")
    ]
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.reconnect()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.blackColor()
    
    let centerX = self.view.bounds.width / 2
    let marginX = round(centerX / 1.7)
    
    let centerY = self.view.bounds.height / 2
    let startY = centerY - 76 / 2 - 60 - 76
    
    let power_on = CircleButton(
      frame: CGRectMake(centerX - marginX, startY, 76, 76),
      key: "power_on",
      color: UIColor(red: 0.3137, green: 0.7608, blue: 0.2667, alpha: 1.0),
      image: UIImage(named: "power_on")
    )
    power_on.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(power_on)
    
    let power_off = CircleButton(
      frame: CGRectMake(centerX + marginX - 76, startY, 76, 76),
      key: "power_off",
      color: UIColor(red: 0.7687, green: 0.2616, blue: 0.2538, alpha: 1.0),
      image: UIImage(named: "power_off")
    )
    power_off.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(power_off)
    
    let input_apple = CircleButton(
      frame: CGRectMake(centerX - marginX, startY + (76 + 60) * 1, 76, 76),
      key: "input_apple",
      color: UIColor(red: 0.7608, green: 0.7609, blue: 0.7608, alpha: 1.0),
      image: UIImage(named: "input_apple")
    )
    input_apple.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(input_apple)
    
    let input_wii = CircleButton(
      frame: CGRectMake(centerX + marginX - 76, startY + (76 + 60) * 1, 76, 76),
      key: "input_wii",
      color: UIColor(red: 0.7608, green: 0.7609, blue: 0.7608, alpha: 1.0),
      image: UIImage(named: "input_wii")
    )
    input_wii.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(input_wii)
    
    let volume_down = CircleButton(
      frame: CGRectMake(centerX - marginX, startY + (76 + 60) * 2, 76, 76),
      key: "volume_down",
      color: UIColor(red: 0.4493, green: 0.2424, blue: 0.7719, alpha: 1.0),
      image: UIImage(named: "volume_down")
    )
    volume_down.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(volume_down)
    
    let volume_up = CircleButton(
      frame: CGRectMake(centerX + marginX - 76, startY + (76 + 60) * 2, 76, 76),
      key: "volume_up",
      color: UIColor(red: 0.4493, green: 0.2424, blue: 0.7719, alpha: 1.0),
      image: UIImage(named: "volume_up")
    )
    volume_up.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(volume_up)
  }

  
  func handleButton(button:CircleButton) {
    sendCommand(button.key)
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
      print("began")
    }
    else if recognizer.state == UIGestureRecognizerState.Changed {
      
    }
    else if recognizer.state == UIGestureRecognizerState.Ended {
      print("ended")
    }
  }
  
  func reconnect() {
    self.sender.connect("10.0.0.18")
  }
  
  private func sendCommand(key:String) {
    if let cmds = self.commands[key] {
      for cmd in cmds {
        sender.send(cmd)
      }
    }
  }

}

