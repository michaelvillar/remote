//
//  TodayViewController.swift
//  RemoteTodayExtension
//
//  Created by Michaël Villar on 10/8/15.
//  Copyright © 2015 michaelvillar. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
  
  private var sender:IRSender?
  
  override var nibName: String? {
    return "TodayViewController"
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    print("aaa")
    completionHandler(.NoData)
    
    self.sender = IRSender(ip: MVHost)
    self.sender?.connect()
    if let command = MVCommands["power_on"] {
      self.sender?.send(command[0])
    }
  }
  
}
