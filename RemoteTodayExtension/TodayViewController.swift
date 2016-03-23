//
//  TodayViewController.swift
//  RemoteTodayExtension
//
//  Created by Michaël Villar on 10/8/15.
//  Copyright © 2015 michaelvillar. All rights reserved.
//

import Cocoa
import NotificationCenter

private let greenColor:NSColor = NSColor(red: 0.3137, green: 0.7608, blue: 0.2667, alpha: 1.0)
private let redColor:NSColor = NSColor(red: 0.7687, green: 0.2616, blue: 0.2538, alpha: 1.0)
private let purpleColor:NSColor = NSColor(red: 0.4493, green: 0.2424, blue: 0.7719, alpha: 1.0)
private let grayColor:NSColor = NSColor(red: 0.7608, green: 0.7609, blue: 0.7608, alpha: 1.0)

class TodayViewController: NSViewController, NCWidgetProviding {
  
  private var sender:IRSender?
  private var colorsForKeys:[String:NSColor] = [String:NSColor]()
  
  override var nibName: String? {
    return "TodayViewController"
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    completionHandler(.NoData)
    
    self.sender = IRSender(ip: MVHost)
    self.sender?.connect()
  }
  
  override func loadView() {
    super.loadView()
    
    self.colorsForKeys["power_on"] = greenColor
    self.colorsForKeys["power_off"] = redColor
    self.colorsForKeys["volume_up"] = purpleColor
    self.colorsForKeys["volume_down"] = purpleColor
    self.colorsForKeys["input_apple"] = grayColor
    self.colorsForKeys["input_wii"] = grayColor
    
    let size: CGFloat = 35
    let startX: CGFloat = 0.0
    let startY: CGFloat = 0.0

    self.preferredContentSize = NSMakeSize(round(size * 1.52) + size, round(size * 1.68 * 2) + size)

    let power_on = CircleButton(
      frame: CGRectMake(startX, startY + round(size * 1.68 * 2), size, size),
      key: "power_on",
      color: self.colorsForKeys["power_on"],
      image: NSImage(named: "power_on")
    )
    power_on.action = "handleButton:"
    power_on.target = self
    self.view.addSubview(power_on)
    
    let power_off = CircleButton(
      frame: CGRectMake(startX + round(size * 1.52), startY + round(size * 1.68 * 2), size, size),
      key: "power_off",
      color: self.colorsForKeys["power_off"],
      image: NSImage(named: "power_off")
    )
    power_off.action = "handleButton:"
    power_off.target = self
    self.view.addSubview(power_off)
    
    let input_apple = CircleButton(
      frame: CGRectMake(startX, startY + round(size * 1.68), size, size),
      key: "input_apple",
      color: self.colorsForKeys["input_apple"],
      image: NSImage(named: "input_apple")
    )
    input_apple.action = "handleButton:"
    input_apple.target = self
    self.view.addSubview(input_apple)
    
    let input_wii = CircleButton(
      frame: CGRectMake(startX + round(size * 1.52), startY + round(size * 1.68), size, size),
      key: "input_wii",
      color: self.colorsForKeys["input_wii"],
      image: NSImage(named: "input_wii")
    )
    input_wii.action = "handleButton:"
    input_wii.target = self
    self.view.addSubview(input_wii)
    
    let volume_down = CircleButton(
      frame: CGRectMake(startX, startY, size, size),
      key: "volume_down",
      color: self.colorsForKeys["volume_down"],
      image: NSImage(named: "volume_down")
    )
    volume_down.action = "handleButton:"
    volume_down.target = self
    self.view.addSubview(volume_down)
    
    let volume_up = CircleButton(
      frame: CGRectMake(startX + round(size * 1.52), startY, size, size),
      key: "volume_up",
      color: self.colorsForKeys["volume_up"],
      image: NSImage(named: "volume_up")
    )
    volume_up.action = "handleButton:"
    volume_up.target = self
    self.view.addSubview(volume_up)
  }
  
  func handleButton(button:CircleButton) {
    sendCommand(button.key)
  }
  
  func sendCommand(key:String) {
    if let cmds = MVCommands[key] {
      for cmd in cmds {
        self.sender?.send(cmd)
      }
    }
  }
}
