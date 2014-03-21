//
//  STKNetConnection.m
//  NetTest
//
//  Created by Nils on Jul 30, 2013.
//  Copyright (c) 2013 Nils. All rights reserved.
//

#import "STKNetConnection.h"

#import <GCDAsyncSocket.h>

#import "STKMessageCenter.h"
#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"
#import "RC4.h"

#include <netinet/tcp.h>
#include <netinet/in.h>

#define TAG_MSG_LENGTH 1
#define TAG_MSG_DATA 2
#define USE_TCP_NODELAY NO

@interface STKNetConnection()

@property(nonatomic) GCDAsyncSocket* socket;
@property(nonatomic,copy) void (^connectCallback)(void);
@property(nonatomic,copy) void (^disconnectCallback)(void);

@property(nonatomic) RC4* enc;
@property(nonatomic) RC4* dec;

@end

@implementation STKNetConnection

- (id)init
{
    if(self = [super init])
    {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	}
    
    return self;
}

- (void)beginConnectToHost:(NSString*)host onPort:(uint16_t)port onConnect:(void(^)(void))connectCallback onDisconnect:(void(^)(void))disconnectCallback
{
    NSLog(@"Network: begin connecting to %@:%d...", host, port);
	
    self.connectCallback = connectCallback;
	self.disconnectCallback = disconnectCallback;
    [self.socket connectToHost:host onPort:port withTimeout:5 error:nil];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sender withError:(NSError*)error
{
    NSLog(@"Network: disconnected / connect timeout!");
	
	// Notify disconnection?
	if(self.disconnectCallback)
	{
		self.disconnectCallback();
		self.disconnectCallback = nil;
	}
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString*)host port:(uint16_t)port
{
	// Connected!
    NSLog(@"Network: connected to %@:%d", host, port);
	if(self.connectCallback)
	{
		self.connectCallback();
		self.connectCallback = nil;
	}
	
	// Disable Nagle's algorithm to reduce latency on small packets
	if(USE_TCP_NODELAY)
	{
		[sock performBlock:^
		 {
			 int on = 1;
			 if(setsockopt([sock socketFD], IPPROTO_TCP, TCP_NODELAY, (char*)&on, sizeof(on)) == 0)
			 {
				 NSLog(@"Network: TCP_NODELAY enabled");
			 }
			 else
			 {
				 NSLog(@"Network: could not enable TCP_NODELAY?!");
			 }
		 }];
	}
    
    // Kick off the message reading & handling loop
    [self beginReceiveMessage];
}

- (void)disconnect:(NSString*)reason
{
    if([self.socket isConnected])
    {
        NSLog(@"Network: closing (\"%@\")", reason);
        [self.socket disconnectAfterReadingAndWriting];
    }
}

- (void)sendMessage:(STKOutgoingMessage*)msg
{
    if([self.socket isConnected])
    {
		// Encrypt entire buffer?
		NSMutableData* buf = [msg finalizeBuffer];
		if(self.enc)
		{
			[self.enc cipherMutableData:buf];
		}
		
        // Write entire buffer
        [self.socket writeData:buf withTimeout:-1 tag:-1];
        NSLog(@"Network: sent msg (#%d, %d bytes)", msg.op, (int)buf.length);
    }
}

- (void)beginReceiveMessage
{
    // Wait for length header (2 bytes)
    [self.socket readDataToLength:sizeof(int16_t) withTimeout:-1 tag:TAG_MSG_LENGTH];
}

- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData *)data withTag:(long)tag
{
	// Decrypt buffer?
	if(self.dec)
	{
		data = [self.dec cipherData:data];
	}
	
    if(tag == TAG_MSG_LENGTH)
    {
        // Read length header (always plain)
        int16_t length = CFSwapInt16BigToHost(*(int16_t*)([data bytes]));
        
        // Now wait for all the data
        [self.socket readDataToLength:length withTimeout:-1 tag:TAG_MSG_DATA];
    }
    else if(tag == TAG_MSG_DATA)
    {
        // Handle the message
        STKIncomingMessage* msg = [[STKIncomingMessage alloc] initWithData:data];
		[[STKMessageCenter sharedCenter] handleMessage:msg];
                
        // Read next message
        [self beginReceiveMessage];
    }
}

- (void)enableEncryptionWithKey:(NSData*)key
{
    self.enc = [RC4 forKeyData:key];
}

- (void)enableDecryptionWithKey:(NSData*)key
{
    self.dec = [RC4 forKeyData:key];
}

@end