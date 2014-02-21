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
	// Create and plug connection
	STKCore* core = self.core;
	STKNetConnection* connection = [STKNetConnection new];
	[core installComponent:connection withKey:@"connection"];
	
	// Begin connecting (async)...
	[connection beginConnectToHost:@"192.168.1.108" onPort:13381
	 
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
		 [core[@"client"] didDisconnectFromServer];
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
		NSString* clientKey = @"edwardsnowden";
		
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
