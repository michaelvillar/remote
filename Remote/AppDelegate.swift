//
//  AppDelegate.swift
//  Remote
//
//  Created by Michaël Villar on 7/25/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window:UIWindow?
  var viewController:ViewController!
  var launchedShortcutItem: UIApplicationShortcutItem?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.viewController = ViewController()
    
    self.window = UIWindow()
    self.window?.makeKeyAndVisible()
    self.window?.frame = UIScreen.mainScreen().bounds
    self.window?.rootViewController = self.viewController
    
    if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
      launchedShortcutItem = shortcutItem
    }
    
    return true
  }
  
  func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
    switch shortcutItem.type {
    case "com.michaelvillar.remote.power_on":
      self.viewController.sendCommand("power_on")
      break
    case "com.michaelvillar.remote.power_off":
      self.viewController.sendCommand("power_off")
      break
    case "com.michaelvillar.remote.input_wii":
      self.viewController.sendCommand("input_wii")
      break
    case "com.michaelvillar.remote.input_apple":
      self.viewController.sendCommand("input_apple")
      break
    default:
      break
    }
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    self.viewController.reconnect()
  }


}

