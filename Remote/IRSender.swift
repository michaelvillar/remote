//
//  IRSender.swift
//  Remote
//
//  Created by Michaël Villar on 7/27/15.
//  Copyright (c) 2015 michaelvillar. All rights reserved.
//

import Foundation

class IRSender: NSObject, NSStreamDelegate {
  private var inputStream:NSInputStream!
  private var outputStream:NSOutputStream!
  private var currentId:Int = 0
  private var queues:[Int:[IRCommand]] = [Int:[IRCommand]]()
  private var availableChannels:[Int:Bool] = [Int:Bool]()
  
  override init() {
    super.init()
  }
  
  func connect(ip:String) {
    var readStream:Unmanaged<CFReadStream>?
    var writeStream:Unmanaged<CFWriteStream>?
    CFStreamCreatePairWithSocketToHost(nil, ip as NSString, 4998, &readStream, &writeStream)
    inputStream = readStream!.takeRetainedValue()
    outputStream = writeStream!.takeRetainedValue()
    inputStream.delegate = self
    outputStream.delegate = self
    inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    inputStream.open()
    outputStream.open()
  }
  
  func send(cmd:IRCommand) {
    if queues[cmd.channel] == nil {
      queues[cmd.channel] = []
    }
    queues[cmd.channel]?.append(cmd)
    tryChannel(cmd.channel)
  }
  
  func stream(stream: NSStream, handleEvent event: NSStreamEvent) {
    switch(event) {
    case NSStreamEvent.OpenCompleted:
      print("connected!")
      break
    case NSStreamEvent.HasBytesAvailable:
      print("has bytes available!")
      if(stream == inputStream) {
        read()
      }
      break
    case NSStreamEvent.EndEncountered:
      print("end!")
      break
    case NSStreamEvent.ErrorOccurred:
      print("error")
      break
    case NSStreamEvent.HasSpaceAvailable:
      print("space available")
      break
    default:
      print("default", event)
    }
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    print(keyPath)
  }
  
  private func read() {
    var buffer = [UInt8](count: 4096, repeatedValue: 0)
    while (inputStream.hasBytesAvailable){
      let len = inputStream.read(&buffer, maxLength: buffer.count)
      if(len > 0){
        let output = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
        print("<< \(output)")
        if (output != ""){
          let lines = output?.componentsSeparatedByString("\r") ?? []
          for line in lines {
            let str = line 
            if !(str as NSString).hasPrefix("completeir") {
              continue
            }
            let args = (str.componentsSeparatedByString(",") ?? [])[1].componentsSeparatedByString(":")
            if let channelStr = args[1] as? String {
              let channel = (channelStr as NSString).integerValue
              availableChannels[channel] = true
              tryChannel(channel)
            }
          }
        }
      }
    }
  }
  
  private func tryChannel(channel:Int) {
    if availableChannels[channel] == nil {
      availableChannels[channel] = true
    }
    
    if queues[channel]?.count == 0 || queues[channel]?.count == nil {
      return
    }
    if availableChannels[channel] == false {
      return
    }
    
    availableChannels[channel] = false
    
    let cmd = queues[channel]?.removeAtIndex(0)
    
    currentId += 1
    print("\(NSDate().timeIntervalSince1970) >> send 1:\(cmd!.channel),\(self.currentId)")
    let fullCmd = "sendir,1:\(cmd!.channel),\(self.currentId),\(cmd!.cmd)\r\n"
    let data:NSData = fullCmd.dataUsingEncoding(NSUTF8StringEncoding)!
    outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
  }

}