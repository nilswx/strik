//
//  STKFacebook.h
//  Strik
//
//  Created by Nils on Aug 17, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKFacebookController.h"

#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"

#import <FacebookSDK.h>

#import "STKAlertView.h"

#import "STKFriend.h"
#import "STKAvatar.h"

#define READ_PERMISSIONS @[@"basic_info", @"user_likes", @"user_location"]
#define FRIENDS_FQL @"SELECT uid,name,is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())"

@interface STKFacebookController()

@property BOOL wantServerLink;

@property FBSession* session;
@property (nonatomic) NSMutableDictionary* friends; // Player ID -> STKFriend
@property (nonatomic) NSMutableDictionary* playerFriends;

@end

@implementation STKFacebookController

- (void)componentDidInstall
{
	// Initialize friend lists
	self.friends = [NSMutableDictionary new];
	self.playerFriends = [NSMutableDictionary new];
	
	// Register network events
	[self routeNetMessagesOf:FACEBOOK_STATUS to:@selector(handleFacebookStatus:)];
	[self routeNetMessagesOf:FACEBOOK_FRIEND_PLAYERS to:@selector(handleFacebookFriendPlayers:)];
	[self routeNetMessagesOf:FACEBOOK_FRIENDS_UPDATE to:@selector(handleFacebookFriendsUpdate:)];
}

- (STKFriend*)friendByUserId:(int64_t)userId
{
	return self.friends[@(userId)];
}

- (STKFriend*)friendByPlayerId:(int)playerId
{
	return self.playerFriends[@(playerId)];
}

- (NSMutableDictionary *)allFriends
{
	return self.friends;
}

- (NSMutableDictionary *)facebookOnlyFriends
{
	NSMutableDictionary *facebookOnlyFriends = [NSMutableDictionary dictionary];
	for(STKFriend *friend in [self.friends allValues])
	{
		if(!friend.isPlayer)
		{
			facebookOnlyFriends[@(friend.userId)] = friend;
		}
	}
	return facebookOnlyFriends;
}

- (void)openSessionWithCallback:(void (^)(void))callback
{
	NSLog(@"Facebook: trying to open session...");
	
	// Resume or create a new session and open it
	[FBSession openActiveSessionWithReadPermissions:READ_PERMISSIONS allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
	 {
		 // Success?
		 if(status == FBSessionStateOpen)
		 {
			 // Hurray!
			 NSLog(@"Facebook: session open, I haz a READ token!");
			 
			 // Need to (re)link on server?
			 BOOL tokenChanged = NO;
			 if(!self.isServerLinked || tokenChanged)
			 {
				 self.wantServerLink = YES;
				 [self syncServer];
			 }
			 
			 // Done here!
			 if(callback) callback();
		 }
		 
		 // Noo! Failed!
		 else if(status == FBSessionStateClosedLoginFailed)
		 {
			 // Does the server think we're linked?
			 if(self.isServerLinked)
			 {
				 // Well, until this is fixed... unlink it
				 self.wantServerLink = NO;
				 [self syncServer];
			 }
			 
			 // Was this an error?
			 if(!error)
			 {
				 NSLog(@"Facebook: session opening postponed without error");
			 }
			 else
			 {
				 // Determine the reason
				 id reason = error.userInfo[FBErrorLoginFailedReason];
				 NSLog(@"Facebook: authorization failed with reason: %@", reason);
			 
				 // Changed your mind?
				 if(reason == FBErrorLoginFailedReasonUserCancelledValue || reason == FBErrorLoginFailedReasonUserCancelledSystemValue)
				 {
					 // Aww...
					 [[STKAlertView alertWithTitle:NSLocalizedString(@"Facebook Link Failed", nil) andMessage:NSLocalizedString(@"You changed your mind? No problem! In case you want to link later: visit your settings.", nil)] show];
					 
					 // Done here!
					if(callback) callback();
				 }
				 
				 // Disabled in Settings.app? Fix and come back later! (don't continue)
				 else if(reason == FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue)
				 {
					 [[STKAlertView alertWithTitle:NSLocalizedString(@"Facebook Link Failed", nil) andMessage:NSLocalizedString(@"Go to your device Settings > Facebook and allow Strik, then try again.", nil)] show];
				 }
			 }
		 }
	 }];
}

- (void)syncServer
{
	// Nothing to do here when we are not connected
	if(!self.core[@"session"])
	{
		return;
	}
	
	// Want link on server?
	if(self.wantServerLink)
	{
		// Not link on server?
		if(!self.isServerLinked)
		{
			// Retrieve latest token
			NSString* token = [FBSession activeSession].accessTokenData.accessToken;
			NSLog(@"Facebook: sending token \"%@xxx\" to server", [token substringToIndex:16]);
			
			// Send latest token
			STKOutgoingMessage* msg = [STKOutgoingMessage withOp:FACEBOOK_LINK];
			[msg appendStr:token];
			[self sendNetMessage:msg];
		}
	}
	
	// Don't want link on server?
	else
	{
		// But currently linked on server?
		if(self.isServerLinked)
		{
			// Request to unlink itThis is how we do!
			NSLog(@"Facebook: requesting server to unlink");
			[self sendNetMessage:[STKOutgoingMessage withOp:FACEBOOK_UNLINK]];
		}
	}
}

- (BOOL)isServerLinked
{
	return (self.userId > 0);
}

- (void)handleFacebookStatus:(STKIncomingMessage*)msg
{
	// Update status
	self->_userId = [msg readLong];
	self->_hasClaimedLike = [msg readBool];
	NSLog(@"Facebook: server says %@", (self.isServerLinked ? @"LINKED" : @"UNLINKED"));
	
	// Linked on the server?
	FBSession* session = [FBSession activeSession];
	if(self.isServerLinked)
	{
		// Well then it is wanted!
		self.wantServerLink = YES;
		
		// Needs to open session?
		if(session.isOpen)
		{
			[self reloadFriendList];
		}
		else
		{
			// Reload friendlist first
			[self openSessionWithCallback:^
			 {
				 // Is the new session open?
				 if([FBSession activeSession].isOpen)
				 {
					 [self reloadFriendList];
				 }
			 }];
		}
	}
	else
	{
		// Forcefully delete local token info (just in case)
		[[FBSession activeSession] closeAndClearTokenInformation];
		
		// So, no link on server. But user wants to link?
		if(self.wantServerLink)
		{
			// DO IT!
			[self openSessionWithCallback:nil];
		}
	}
}

- (void)reloadFriendList
{
	// Let's see...
	NSLog(@"Facebook: reloading friendlist...");
	
	// Use FQL to ask FB for all the friend IDs and whether they have authorized with the app
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:@{ @"q": FRIENDS_FQL } HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
	 {
		 if(error)
		 {
			 NSLog(@"Facebook: could not get friend players -> %@", error);
		 }
		 else
		 {
			 // Store FB user IDs of known players
			 NSMutableArray* users = [NSMutableArray new];
			 
			 // Parse data and create placeholder objects
			 [self.friends removeAllObjects];
			 for(FBGraphObject* data in result[@"data"])
			 {
				 // Parse basic friend data
				 STKFriend* friend = [STKFriend new];
				 friend.userId = [data[@"uid"] longLongValue];
				 friend.fullName = data[@"name"];
				 friend.avatar = [STKAvatar avatarWithIdentifier:[NSString stringWithFormat:@"f%lld", friend.userId]];
				 
				 self.friends[@(friend.userId)] = friend;
				 
				 // Uses the game too?
				 if([data[@"is_app_user"] boolValue])
				 {
					 [users addObject:@(friend.userId)];
				 }
			 }
			 NSLog(@"Facebook: reloaded friendlist: %lu friends", (unsigned long)self.friends.count);
			 
			 // Alright, now we need their player IDs
			 NSLog(@"Facebook: submitting %lu app user friends to initialize friend player list", (unsigned long)users.count);
			 
			 // Send the ID's to server
			 STKOutgoingMessage* msg = [STKOutgoingMessage withOp:FACEBOOK_INIT_FRIENDLIST];
			 [msg appendInt:(int)users.count];
			 for(NSNumber *userId in users)
			 {
				 [msg appendLong:[userId longLongValue]];
			 }
			 [self sendNetMessage:msg];
		 }
	 }];
}

- (void)handleFacebookFriendPlayers:(STKIncomingMessage*)msg
{
	// Dump old list
	[self.playerFriends removeAllObjects];
	
	// Read the new list
	int amount = [msg readInt];
	for(int i = 0; i < amount; i++)
	{
		// Read player ID -> userID mapping
		int32_t playerId = [msg readInt];
		int64_t userId = [msg readLong];
		
		// Not a bogus friend?
		STKFriend* friend = self.friends[@(userId)];
		
		if(friend)
		{
			friend.playerId = playerId;
			self.playerFriends[@(playerId)] = friend;
		}
	}
	
	// Need updates?
	if(self.playerFriends.count == 0)
	{
		NSLog(@"Facebook: ZERO friends are players on the servers -> refresh disabled");
	}
	else
	{
		NSLog(@"Facebook: %lu friends are players on the servers -> periodical refresh enabled", (unsigned long)self.playerFriends.count);
		[self refreshFacebookFriendPlayers];
	}
}

- (void)refreshFacebookFriendPlayers
{
	// "Please give me player data updates of friends in the list that I initialized earlier!"
	[self sendNetMessage:[STKOutgoingMessage withOp:FACEBOOK_REFRESH_FRIENDS]];
}

- (void)handleFacebookFriendsUpdate:(STKIncomingMessage*)msg
{
	// Process updates for friend players
	int amount = [msg readInt];
	int onlineCount = 0;
	for(int i = 0; i < amount; i++)
	{
		// Determine friend player
		int playerId = [msg readInt];
		STKFriend* friend = self.playerFriends[@(playerId)];
		
		// Friend in list?
		if(friend)
		{
			// Apply updates
			friend.name = [msg readStr];
			friend.avatar = [STKAvatar avatarWithIdentifier:[msg readStr]];
			friend.motto = [msg readStr];
			friend.isOnline = [msg readBool];
			friend.isInMatch = [msg readBool];
			if(friend.isOnline)
			{
				onlineCount++;
			}
		}
	}
	
	// Done!
	NSLog(@"Facebook: refreshed player data of %d friends (%d online)", amount, onlineCount);
	
	// Refresh again after some time
	[self performSelector:@selector(refreshFacebookFriendPlayers) withObject:nil afterDelay:60];
}

@end
