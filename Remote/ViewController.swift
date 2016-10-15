//
//  ViewController.swift
//  Remote
//
//  Created by Michaël Villar on 7/25/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import UIKit

private let greenColor:UIColor = UIColor(red: 0.3137, green: 0.7608, blue: 0.2667, alpha: 1.0)
private let redColor:UIColor = UIColor(red: 0.7687, green: 0.2616, blue: 0.2538, alpha: 1.0)
private let purpleColor:UIColor = UIColor(red: 0.4493, green: 0.2424, blue: 0.7719, alpha: 1.0)
private let grayColor:UIColor = UIColor(red: 0.7608, green: 0.7609, blue: 0.7608, alpha: 1.0)

class ViewController: UIViewController, UIGestureRecognizerDelegate, IRSenderDelegate {
  
  private var colorsForKeys:[String:UIColor] = [String:UIColor]()
  private let sender:IRSender!
  private let label:UILabel = UILabel(frame: CGRectZero)
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    self.sender = IRSender(ip: MVHost)
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.colorsForKeys["power_on"] = greenColor
    self.colorsForKeys["power_off"] = redColor
    self.colorsForKeys["volume_up"] = purpleColor
    self.colorsForKeys["volume_down"] = purpleColor
    self.colorsForKeys["input_apple"] = grayColor
    self.colorsForKeys["input_wii"] = grayColor
    
    for (key, commands) in MVCommands {
      for command in commands {
        command.userInfo = self.colorsForKeys[key]
      }
    }
    
    self.sender.delegate = self
    self.reconnect()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.blackColor()
    
    let centerX = self.view.bounds.width / 2
    let startX = centerX - 20 - 76
    
    let centerY = self.view.bounds.height / 2
    let startY = centerY - 76 / 2 - 60 - 76
    
    let power_on = CircleButton(
      frame: CGRectMake(startX, startY, 76, 76),
      key: "power_on",
      color: self.colorsForKeys["power_on"],
      image: UIImage(named: "power_on")
    )
    power_on.addTarget(self, action: #selector(ViewController.handleButton(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(power_on)
    
    let power_off = CircleButton(
      frame: CGRectMake(startX + 76 + 40, startY, 76, 76),
      key: "power_off",
      color: self.colorsForKeys["power_off"],
      image: UIImage(named: "power_off")
    )
    power_off.addTarget(self, action: #selector(ViewController.handleButton(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(power_off)
    
    let input_apple = CircleButton(
      frame: CGRectMake(startX, startY + (76 + 60) * 1, 76, 76),
      key: "input_apple",
      color: self.colorsForKeys["input_apple"],
      image: UIImage(named: "input_apple")
    )
    input_apple.addTarget(self, action: #selector(ViewController.handleButton(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(input_apple)
    
    let input_wii = CircleButton(
      frame: CGRectMake(startX + 76 + 40, startY + (76 + 60) * 1, 76, 76),
      key: "input_wii",
      color: self.colorsForKeys["input_wii"],
      image: UIImage(named: "input_wii")
    )
    input_wii.addTarget(self, action: #selector(ViewController.handleButton(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(input_wii)
    
    let volume_down = CircleButton(
      frame: CGRectMake(startX, startY + (76 + 60) * 2, 76, 76),
      key: "volume_down",
      color: self.colorsForKeys["volume_down"],
      image: UIImage(named: "volume_down")
    )
    volume_down.addTarget(self, action: #selector(ViewController.handleButton(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(volume_down)
    
    let volume_up = CircleButton(
      frame: CGRectMake(startX + 76 + 40, startY + (76 + 60) * 2, 76, 76),
      key: "volume_up",
      color: self.colorsForKeys["volume_up"],
      image: UIImage(named: "volume_up")
    )
    volume_up.addTarget(self, action: #selector(ViewController.handleButton(_:)), forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(volume_up)
  }
  
  func handleButton(button:CircleButton) {
    sendCommand(button.key)
  }
  
  func reconnect() {
    self.sender.connect()
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  func sendCommand(key:String) {
    if let cmds = MVCommands[key] {
      for cmd in cmds {
        sender.send(cmd)
      }
    }
  }
  
  private func animateSignal(color: UIColor) {
    let centerY = self.view.bounds.height / 2
    let startY = centerY - 76 / 2 - 60 - 76
    let width:CGFloat = 192
    
    let signalView = UIView(frame: CGRectMake(self.view.bounds.width / 2 - width / 2, startY / 2 - 1, width, 2))
    signalView.backgroundColor = color
    signalView.transform = CGAffineTransformMakeScale(12.0 / width, 1)
    self.view.addSubview(signalView)
    
    UIView.animateWithDuration(0.5,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: {
        signalView.transform = CGAffineTransformIdentity
      }) { (bool) -> Void in
    }
    
    UIView.animateWithDuration(0.5,
      delay: 0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        signalView.alpha = 0.0
      }) { (bool) -> Void in
        signalView.removeFromSuperview()
    }
  }
  
  // IRSenderDelegate
  func senderDidSendCommand(sender: IRSender, cmd: IRCommand) {
    animateSignal(cmd.userInfo as! UIColor)
  }
  
  func senderDidFailToSendCommand(sender: IRSender, cmd: IRCommand) {
    let centerY = self.view.bounds.height / 2
    let startY = centerY - 76 / 2 - 60 - 76
    let width:CGFloat = 192
    label.frame = CGRectMake(self.view.bounds.width / 2 - width / 2, startY / 2 - 13, width, 26)
    label.backgroundColor = UIColor.clearColor()
    label.textColor = UIColor(red: 0.7608, green: 0.7608, blue: 0.7608, alpha: 0.5)
    label.textAlignment = NSTextAlignment.Center
    label.text = "You are not connected"
    label.alpha = 1.0
    self.view.addSubview(label)
    
    UIView.animateWithDuration(0.5,
      delay: 0.85,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: {
        self.label.alpha = 0.0
      }) { (bool) -> Void in
        if bool {
          self.label.removeFromSuperview()
        }
    }
  }

}

