//
//  STKSession.m
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKSessionController.h"

#import <UIDeviceHardware.h>

#import "STKPlayer.h"
#import "STKInventory.h"
#import "STKDirector.h"
#import "STKClientController.h"
#import "STKAlertView.h"
#import "STKOutgoingMessage.h"
#import "STKProgression.h"
#import "STKMatchController.h"
#import "STKItemRegistry.h"
#import "STKInAppPurchasesController.h"
#import "STKAvatar.h"
#import "STKFacebookController.h"
#import "STKDirector+Modal.h"

#import "STKHomeController.h"

@implementation STKSessionController

- (void)componentDidInstall
{
	// No user data yet, empty inventory
	self.player = nil;
	self.inventory = [STKInventory new];
	
	// Install match controller
    [self.core installComponent:[STKMatchController new] withKey:@"match"];
	
	// Don't install the item registry for now
	//[self.core installComponent:[STKItemRegistry new] withKey:@"items"];
	
	// Related to session user and login
	[self routeNetMessagesOf:CREDENTIALS to:@selector(handlePlayerCredentials:)];
	[self routeNetMessagesOf:PLAYER_INFO to:@selector(handlePlayerInfo:)];
	[self routeNetMessagesOf:PLAYER_UNKNOWN to:@selector(handlePlayerUnknown:)];

    // Related to XP
    [self routeNetMessagesOf:LEVELS to:@selector(handleLevels:)];
    [self routeNetMessagesOf:EXPERIENCE_ADDED to:@selector(handleExperience:)];
	
	// Related to avatar
	[self routeNetMessagesOf:AVATAR_CHANGED to:@selector(handleAvatarChanged:)];

	// Nice!
	NSLog(@"Session: I am session #%ld on server %@", self.sessionId, self.server);
	
	// Okay, what's next?
	[self.core[@"client"] registerOrLogin];
}


- (void)componentDidUninstall
{
	// We installed it, we remove it!
	[self.core uninstallComponent:@"match"];
}

- (void)createNewPlayer
{
	NSLog(@"Session: requesting new player account...");
	
	// Request a new user account (receive CREDENTIALS = register OK)
	[self sendNetMessage:[STKOutgoingMessage withOp:CREATE_PLAYER]];
}

- (void)handlePlayerCredentials:(STKIncomingMessage*)msg
{
	// Parse the credentials
	int playerId = [msg readInt];
	NSString* token = [msg readStr];
	NSLog(@"Session: received player credentials");
	
	// Store them locally for further logins
	if([self.core[@"client"] storePlayerID:playerId andToken:token])
	{
		// Already logged in?
		if(self.player)
		{
			// Hurray!
			NSLog(@"Session: recovered account #%d!", playerId);
			
			// Give the user something to look at (lol fix this)
			[[STKAlertView alertWithTitle:NSLocalizedString(@"Account Downloaded", nil) andMessage:NSLocalizedString(@"Downloaded your previous account. Hang on...", nil)] show];
			
			// Server will disconnect us now. Wait for client to reconnect, so it logs in to the account.

		}
		else
		{
			// New account created!
			[self loginWithPlayerID:playerId andToken:token];
		}
	}
	else
	{
		NSLog(@"Session: could not store new credentials?!");
	}
}

- (void)loginWithPlayerID:(int)playerId andToken:(NSString*)token
{
	// Let's do this
	NSLog(@"Session: logging in... [player ID: #%d]", playerId);
	
	// Send credentials (receive PLAYER_INFO = login OK)
	STKOutgoingMessage* login = [STKOutgoingMessage withOp:LOGIN];
	[login appendInt:playerId];
	[login appendStr:token];
	[login appendStr:[UIDeviceHardware platform]];
	[login appendStr:[[UIDevice currentDevice] systemVersion]];
	[self sendNetMessage:login];
}

- (void)handlePlayerUnknown:(STKIncomingMessage*)msg
{
	// Who?
	int playerId = [msg readInt];
	
	// Is it about us?
	if(!self.player || playerId == self.player.playerId)
	{
		// What happened?
		if(self.player)
		{
			NSLog(@"Session: server deleted account successfully!");
			
			// Sniff sniff...
			[[STKAlertView alertWithTitle:NSLocalizedString(@"Account Deleted", nil) andMessage:NSLocalizedString(@"Your account was deleted successfully. Bye!", nil)] show];
		}
		else
		{
			NSLog(@"Session: login on player #%d failed, cannot use this account", playerId);
			
			// Server doesn't recognize this account anymore
			[[STKAlertView alertWithTitle:NSLocalizedString(@"Account Unknown", nil) andMessage:NSLocalizedString(@"Oh no! Your account is invalid or no longer exists...", nil)] show];
		}
		
		// Get rid of our stuff :(
		[self.core[@"client"] clearCredentials];
	}
	
	// Or some other (requested) account does not exist
	else
	{
		// /care
	}
}

- (void)handlePlayerInfo:(STKIncomingMessage*)msg
{
	// Process player data
	self.player = [STKPlayer playerFromMessage:msg];
	int lastOnlineTime = [msg readInt];
	NSLog(@"Session: login OK, identified as #%d (\"%@\"), last online = %d", self.player.playerId, self.player.name, lastOnlineTime);
	
	// Get IAP's
	[self.core[@"iap"] refreshProducts];
    
	// Go Home, matey!
	
	// First load the current users avatar, so it won't pop in after showing the scene
	[self.player.avatar fetchAvatarWithCallback:^(CCTexture *avatarTexture, AvatarType avatarType) {
		STKDirector *director = self.core[@"director"];
		[director presentScene:[STKHomeController new]];
	}];
}

- (void)handleExperience:(STKIncomingMessage *)message
{
    int added = [message readInt];
    int total = [message readInt];

    self.player.progression.xp = total;
}

- (void)handleLevels:(STKIncomingMessage *)message
{
    NSMutableArray *levels = [NSMutableArray array];

    int length = [message readByte];

    int currentXP;
    int lastXP;

    for(int i = 0; i < length; i++)
    {
        if(i > 0)
        {
            lastXP = currentXP;
        }

        currentXP = [message readInt];

        if(i > 0)
        {
            STKLevel level;
            level.begin = lastXP;
            level.end = currentXP -1;

            [levels addObject:[NSValue value:&level withObjCType:@encode(STKLevel)]];
        }
    }

    [STKProgression setLevels:[NSArray arrayWithArray:levels]];
}

- (void)handleAvatarChanged:(STKIncomingMessage *)message
{
	// Avatar changed
	NSString *identifier = [message readStr];
	
	// Change avatar
	self.player.avatar = [STKAvatar avatarWithIdentifier:identifier];
	
	// Hide the overlay
	STKDirector *director = self.core[@"director"];
	[director hideOverlay];
}

@end
