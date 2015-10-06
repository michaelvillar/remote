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

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.viewController = ViewController()
    
    self.window = UIWindow()
    self.window?.makeKeyAndVisible()
    self.window?.frame = UIScreen.mainScreen().bounds
    self.window?.rootViewController = self.viewController
    
    return true
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    self.viewController.reconnect()
  }


}

