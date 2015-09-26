//
//  itachIP2IR.m
//  itachIP2IR
//
//  Created by colossus on 4/19/14.
//  Copyright (c) 2014 colossus. All rights reserved.
//

#import "itachIP2IR.h"
#import <arpa/inet.h>
#import <sys/socket.h>
#include <netdb.h>
#include <errno.h>

#ifdef DEBUG
#   define DLog(...) NSLog(__VA_ARGS__)
#else
#   define DLog(...)
#endif

/*http://www.globalcache.com/files/docs/API-iTach.pdf*/
#define ITACH_BROADCAST_PORT 9131
#define ITACH_BROADCAST_GROUP 239.255.250.250
#define BUF_SIZE 1024

@implementation itachIP2IR
@synthesize itachIP;
+(id)sharedInstance
{
    static itachIP2IR *sharedItach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedItach = [[self alloc] init];
        [sharedItach setItachPort:@"4998"];
    });
    return sharedItach;
}



- (void)sendCommand: (NSString *)request {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(!_commandList){
            NSLog(@"[itachIP2IR] ERROR: command list not set");
            return;
        }
        
        
        NSString *requestStrFrmt = [_commandList objectForKey:request];
        if(!requestStrFrmt){
            NSLog(@"[itachIP2IR] no key for %@",request);
            return;
        }
        
        struct addrinfo *servInfo;
        
        struct addrinfo hints;
        memset(&hints, 0, sizeof hints);
        hints.ai_family = PF_INET;
        hints.ai_socktype = SOCK_STREAM;
        int res = getaddrinfo([itachIP UTF8String], [_itachPort UTF8String], &hints, &servInfo);
        
        if (res != 0) {
            //                EAI_ADDRFAMILY
            NSLog(@"WARN: Could not connect to host.  Please assign a delegate to the network controller to avoid this log message in the future");
            return;
        }
        struct sockaddr *addr = servInfo->ai_addr;
        
        if(!my_socket)
            my_socket = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
        
        if (my_socket < 0) {
            DLog(@"[itachIP2IR] could not create socket");
            return;
        }
        
        int yes = 1;
        if(setsockopt(my_socket, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
            perror("setsockopt");
            exit(1);
        }
        
        
        res = connect(my_socket, addr, sizeof(struct sockaddr));
        if (res < 0) {
            NSLog(@"error no %d",errno);
            close(my_socket);
            my_socket = 0;
            return;
        }
        
        NSError *error;
        NSData *requestData = [requestStrFrmt dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSData *jsonData = requestData;
        if (error) {
            NSLog(@"could not decode data from host");
            return;
        }
        send(my_socket, [jsonData bytes], [jsonData length], 0);
        
        
        DLog(@"[itachIP2IR] sent %lu byte message",(unsigned long)[jsonData length]);
        
        //Get data back
        char buffer[5000];
        int numBytes = 0;
        char *ptr = buffer;
        
        struct timeval tv;
        
        tv.tv_sec = 2;  /* 30 Secs Timeout */
        tv.tv_usec = 0;  // Not init'ing this can cause strange errors
        setsockopt(my_socket, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv,sizeof(struct timeval));
        
        int nRecv = recv(my_socket, ptr, sizeof(buffer), 0);
        
        DLog(@"[itachIP2IR] Received : %@",[NSString stringWithCString:ptr encoding:NSUTF8StringEncoding]);
        
        close(my_socket);
        my_socket = 0;
    });
}

-(void)discover
{
    // descriptor number for the socket we'll use
    int serverSocket;
    
    // socket internet address data for the server
    struct sockaddr_in serverData;
    
    // socket internet address data for a client
    struct sockaddr_in clientData;
    int clientDataLength;
    
    // buffer for incoming data
    char buffer[1024];
    
    bool isConnected;
    
    int bytesReceived;
    
    /*
     * Set up the server
     */
    bzero( &serverData, sizeof( serverData ) );
    // use the Internet Address Family (IPv4)
    serverData.sin_family = AF_INET;
    // accept connections from a client on broadcast
    serverData.sin_addr.s_addr = htonl( INADDR_BROADCAST );
    // set the port for incoming packets
    serverData.sin_port = htons( ITACH_BROADCAST_PORT );
    
    
    // zero-out the client address struct too
    bzero( &clientData, sizeof( clientData ) );
    
    /*
     * Open a UDP (datagram) socket
     * (and save the descriptor so we can refer to it in the future)
     */
    // the third argument is for setting different protocols on sockets,
    // we don't need to worry about this and are using 0
    // PF_INET means the internet protocol family
    serverSocket = socket( PF_INET, SOCK_DGRAM, 0 );
    
    // bind the socket to the address
    int bindResult = bind( serverSocket,
                          (struct sockaddr *)&serverData,
                          sizeof( serverData ) );
    if ( bindResult < 0 ) {
        printf( "Error: Unable to bind socket" );
        close( serverSocket );
    } else {
        printf( "Server Running\n" );
        
        isConnected = true;
        while ( isConnected ) {
            
            // it's important to specify this size first
            clientDataLength = sizeof( clientData );
            
            // receive any data from a client
            bytesReceived = recvfrom( serverSocket, buffer, BUF_SIZE, 0, // extra flags
                                     (struct sockaddr *)&clientData, &clientDataLength );
            
            // terminate the bytes as a string and print the result
            buffer[bytesReceived]= '\0';
            char *clientAddress = inet_ntoa( clientData.sin_addr );
            printf( "Received:\n%s\nfrom: %s:%d\n",
                   buffer,
                   clientAddress,
                   ntohs( clientData.sin_port ) );
            
            // reply
            char replyText[] = "Datagram received!";
            strncpy( buffer, replyText, strlen( replyText ) );
            printf( "Replying with: %s\n", buffer );
            
            sendto( serverSocket, buffer, strlen( replyText ), 0, // extra flags
                   (struct sockaddr *)&clientData, clientDataLength );
        }
        close( serverSocket );
    }}


-(void)cleanup
{
    close(my_socket);
}
@end
