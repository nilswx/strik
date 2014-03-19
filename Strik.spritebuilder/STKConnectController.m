//
//  STKConnectController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 20/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKConnectController.h"
#import "STKClientController.h"
#import "STKNetConnection.h"
#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"
#import "STKClientController.h"
#import "STKSessionController.h"

@implementation STKConnectController

- (void)enterTransitionDidFinish
{
	[self performSelector:@selector(connectToServer) withObject:nil afterDelay:2];
}


- (void)connectToServer
{
	// Get client controller
	STKClientController* client = self.core[@"client"];
	
	// Determine host/port
	NSString* host;
	int port;

#if defined(SERVER_HOST) && defined(SERVER_PORT)
	
	host = SERVER_HOST;
	port = SERVER_PORT;
	
#else

	// Get url of loadbalancer
	NSURL* loadBalancerURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", LOADBALANCER_HOST, LOADBALANCER_PORT]];
	NSLog(@"Connect: contacting load balancer at %@:%d...", LOADBALANCER_HOST, LOADBALANCER_PORT);
	
	// Fetch result (blocking call)
	NSError* error;
	NSString* result = [NSString stringWithContentsOfURL:loadBalancerURL encoding:NSASCIIStringEncoding error:&error];
	
	// Error?
	if(error)
	{
		NSLog(@"Connect: error contacting load balancer: %@", error);
		
		// Retry later
		[client didDisconnectFromServer];
		return;
	}
	else
	{
		// Parse it!
		NSArray* parts = [result componentsSeparatedByString:@":"];
		host = [parts[0] stringValue];
		port = [parts[1] intValue];
	}
#endif
	
	// Create and plug connection
	STKCore* core = self.core;
	STKNetConnection* connection = [STKNetConnection new];
	[core installComponent:connection withKey:@"connection"];
	
	// Begin connecting (async)...
	[connection beginConnectToHost:host onPort:port

	 // Connected!
	onConnect:^
	{
		// Continue with the login etc
		[self didConnectToServer];
	}
	 
	 // Disconnected!
	onDisconnect:^
	{
		// Notify the global client controller
		[client didDisconnectFromServer];
	}];
}

- (void)didConnectToServer
{
	[self routeNetMessagesOf:VERSIONCHECK to:@selector(handleVersionCheck:)];
	[self routeNetMessagesOf:SERVER_CRYPTO to:@selector(handleServerCrypto:)];
	[self routeNetMessagesOf:SESSION_INFO to:@selector(handleSessionInfo:)];
}

- (void)handleVersionCheck:(STKIncomingMessage*)msg
{
	// Read required version
	int8_t reqMajor = [msg readByte];
	int8_t reqMinor = [msg readByte];
	NSString* tag = [msg readStr];
	
	// Version matches?
	int8_t myMajor = 1;
	int8_t myMinor = 0;
	if(myMajor == reqMajor && myMinor == reqMinor)
	{
		NSLog(@"Handshake: version OK! (v%d.%d \"%@\")", reqMajor, reqMinor, tag);
	}
	else
	{
		NSLog(@"Handshake: version too old (have v%d.%d, need v%d.%d \"%@\")", myMajor, myMinor, reqMajor, reqMinor, tag);
		
		//[self showAlert:[NSString stringWithFormat: @"Your Strik client (v%d.%d) is out of date and must be updated to v%d.%d.", myMajor, myMinor, reqMajor, reqMinor]];
		
		//[self.connection disconnect:@"incorrect version"];
	}
	
}

- (void)handleServerCrypto:(STKIncomingMessage*)msg
{
	NSString* serverKey = [msg readStr];
	if(serverKey.length == 0)
	{
		NSLog(@"Handshake: server is not using encryption");
	}
	else
	{
		// Decrypt new received messages with this key
		STKNetConnection* connection = self.core[@"connection"];
		[connection enableDecryptionWithKey:[serverKey dataUsingEncoding:NSUTF8StringEncoding]];
		
		// Now generate a client-> server encryption key
		NSString* clientKey = [[NSUUID UUID] UUIDString];
		
		// Inform the server (plaintext)
		STKOutgoingMessage* msg = [STKOutgoingMessage withOp:CLIENT_CRYPTO];
		[msg appendStr:clientKey];
		[connection sendMessage:msg];
		
		// Encrypt new sent messages with this key
		[connection enableEncryptionWithKey:[clientKey dataUsingEncoding:NSUTF8StringEncoding]];
		
		// All set
		NSLog(@"Handshake: encryption enabled (ek=\"%@\" dk=\"%@\")", clientKey, serverKey);
	}
	
}

- (void)handleSessionInfo:(STKIncomingMessage*)msg
{
	// Initialize session
	STKSessionController* session = [[STKSessionController alloc] init];
	session.sessionId = [msg readLong];
	session.server = [msg readStr];
	[self.core installComponent:session];
}

@end
