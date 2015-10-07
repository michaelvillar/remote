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
  
  private let commands:[String:[IRCommand]]!
  private let sender:IRSender!
  private let label:UILabel = UILabel(frame: CGRectZero)
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    self.sender = IRSender(ip: "10.0.0.18")

    self.commands = [String:[IRCommand]]()
    self.commands["power_on"] = [
      IRCommand(channel: 1, cmd: "38000,1,69,341,172,21,21,21,65,21,65,21,65,21,21,21,65,21,65,21,65,21,65,21,65,21,65,21,21,21,21,21,21,21,21,21,65,21,65,21,65,21,21,21,21,21,21,21,21,21,21,21,21,21,65,21,65,21,21,21,21,21,21,21,65,21,21,21,21,21,1508,341,85,21,3648", userInfo: greenColor),
      IRCommand(channel: 2, cmd: "38000,1,69,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,1517,341,85,21,3655", userInfo: greenColor),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24", userInfo: greenColor),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,1014,95,24,25,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24", userInfo: greenColor)
    ]
    self.commands["power_off"] = [
      IRCommand(channel: 2, cmd: "38000,1,69,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,21,21,64,21,64,21,21,21,1517,341,85,21,3655", userInfo: redColor),
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,48,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,990,95,24,48,24,48,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,990,95,24,48,24,47,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,25,24,25,24,25,24", userInfo: redColor)
    ]
    self.commands["volume_up"] = [
      IRCommand(channel: 2, cmd: "38000,1,1,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,64,21,64,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,500", userInfo: purpleColor)
    ]
    self.commands["volume_down"] = [
      IRCommand(channel: 2, cmd: "38000,1,1,341,170,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,21,21,21,21,64,21,64,21,64,21,21,21,21,21,21,21,21,21,64,21,21,21,21,21,64,21,64,21,64,21,64,21,64,21,21,21,64,21,64,21,21,21,21,21,500", userInfo: purpleColor),
    ]
    self.commands["input_apple"] = [
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,821,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,821,95,24,25,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,24", userInfo: grayColor)
    ]
    self.commands["input_wii"] = [
      IRCommand(channel: 3, cmd: "40064,1,1,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,798,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,798,95,24,48,24,48,24,25,24,48,24,48,24,25,24,48,24,25,24,48,24,25,24,48,24,48,24,25,24,25,24,25,24", userInfo: grayColor)
    ]
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
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
      color: greenColor,
      image: UIImage(named: "power_on")
    )
    power_on.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(power_on)
    
    let power_off = CircleButton(
      frame: CGRectMake(startX + 76 + 40, startY, 76, 76),
      key: "power_off",
      color: redColor,
      image: UIImage(named: "power_off")
    )
    power_off.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(power_off)
    
    let input_apple = CircleButton(
      frame: CGRectMake(startX, startY + (76 + 60) * 1, 76, 76),
      key: "input_apple",
      color: grayColor,
      image: UIImage(named: "input_apple")
    )
    input_apple.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(input_apple)
    
    let input_wii = CircleButton(
      frame: CGRectMake(startX + 76 + 40, startY + (76 + 60) * 1, 76, 76),
      key: "input_wii",
      color: grayColor,
      image: UIImage(named: "input_wii")
    )
    input_wii.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(input_wii)
    
    let volume_down = CircleButton(
      frame: CGRectMake(startX, startY + (76 + 60) * 2, 76, 76),
      key: "volume_down",
      color: purpleColor,
      image: UIImage(named: "volume_down")
    )
    volume_down.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
    self.view.addSubview(volume_down)
    
    let volume_up = CircleButton(
      frame: CGRectMake(startX + 76 + 40, startY + (76 + 60) * 2, 76, 76),
      key: "volume_up",
      color: purpleColor,
      image: UIImage(named: "volume_up")
    )
    volume_up.addTarget(self, action: "handleButton:", forControlEvents: UIControlEvents.TouchUpInside);
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
    if let cmds = self.commands[key] {
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

