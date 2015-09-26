//
//  itachIP2IR.h
//  itachIP2IR
//
//  Created by colossus on 4/19/14.
//  Copyright (c) 2014 colossus. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol itachIP2IRDelegate
-(NSString*)discoveredItachWithIp;
@end

@interface itachIP2IR : NSObject
{
    int my_socket;
}
//ip commands are forwarded to
@property (nonatomic, strong) NSString* itachIP;
//defaults to 4998
@property (nonatomic, strong) NSString* itachPort;
//mutable dictionary to load with your custom IR commands
@property (nonatomic, strong) NSMutableDictionary*  commandList;

+(id)sharedInstance;
//send itach command with key of your command in commandList
-(void)sendCommand:(NSString*)command;

//calls delegate method didDiscover upon itach discovery
-(void)discover;


@property (nonatomic, weak) id<itachIP2IRDelegate> delegate;
@end
