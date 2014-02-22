//
//  STKClientController.m
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKClientController.h"

#import "STKDirector.h"
#import "STKRemoteServerChallenge.h"

#import "STKAlertView.h"
#import "STKCore.h"
#import "STKSessionController.h"

#import "STKNewPlayerController.h"

#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"

#import "STKNewPlayerController.h"

#import "STKConnectScene.h"
#import "STKConnectController.h"

@interface STKClientController()

@property BOOL autoReconnect;
@property STKRemoteServerChallenge* remoteChallenge;

@end

@implementation STKClientController

- (void)componentDidInstall
{
	// Handle the alerts from the server
	[self routeNetMessagesOf:ALERT to:@selector(handleAlert:)];
	
	// Enable auto reconnecting
	self.autoReconnect = YES;
}

- (void)registerOrLogin
{
	// Fetch credentials
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	int playerId = [[defaults stringForKey:@"playerId"] intValue];
	NSString* token = [defaults stringForKey:@"token"];
	
	// Fetch session
	STKSessionController* session = self.core[@"session"];
	
	// Already got credentials?
	if(playerId && token)
	{
		// Connected?
		if(!session)
		{
			[self connectToServer];
		}
		else
		{
			[session loginWithPlayerID:playerId andToken:token];
		}
	}
	
	// We need to register a new player!
	else
	{
		// Connected?
		if(session)
		{
			[session createNewPlayer];
		}
		else
		{
			STKDirector *director = self.core[@"director"];
			[director presentScene:[STKNewPlayerController new]];
		}
	}
}

- (BOOL)storePlayerID:(int)playerId andToken:(NSString*)token
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:@(playerId) forKey:@"playerId"];
	[defaults setValue:token forKey:@"token"];
	
	return [defaults synchronize];
	
	NSLog(@"Client: stored new player credentials");
}

- (void)clearCredentials
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"playerId"];
	[defaults removeObjectForKey:@"token"];
	[defaults synchronize];
	
	NSLog(@"Client: cleared player credentials");
}

- (void)connectToServer
{
	// Get current scene
	STKDirector* director = self.core[@"director"];

    STKScene *scene = [director isCurrentScene:[STKConnectScene class]];
	
	// Already in connect scene?
    if(scene)
    {
		[scene.controller connectToServer];
	}
    else
    {
        [director presentScene:[STKConnectController new]];
    }
}

- (void)didDisconnectFromServer
{
	// Oh no!
	NSLog(@"Client: disconnected, %@...", (self.autoReconnect ? @"will reconnect soon" : @"will NOT reconnect"));
	
	// Clear connection related stuff
	[self.core uninstallComponent:@"connection"];
	[self.core uninstallComponent:@"session"];
	
	// Do what is neccesary, and do it soon!
	if(self.autoReconnect)
	{
		[self performSelector:@selector(registerOrLogin) withObject:nil afterDelay:3.0];
	}
}

- (void)changeLocale:(NSString*)locale
{
	NSLog(@"Client: changing locale to '%@'", locale);
	
	// TODO: change and refresh user interface texts
	
	// Notify server too
	STKOutgoingMessage* msg = [STKOutgoingMessage withOp:CHANGE_LOCALE];
	[msg appendStr:locale];
	[self sendNetMessage:msg];
}

- (void)launchRemoteChallenge:(STKRemoteServerChallenge*)remoteChallenge
{
	self.remoteChallenge = remoteChallenge;
	
	// Disconnect from this server, connect to specified server, handshake & login, send challenge for user X
}

- (void)handleAlert:(STKIncomingMessage *)message
{
	// Construct server alert message (we don't deal with localized titles! this is just emergency etc!)
	NSString *alertMessage = [message readStr];
	[[STKAlertView alertWithTitle:@"Server" andMessage:alertMessage] show];
}

@end
