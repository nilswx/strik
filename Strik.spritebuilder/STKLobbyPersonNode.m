//
//  STKLobbyPersonNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 24/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLobbyPersonNode.h"
#import "NSObject+Observer.h"

#import "STKAvatarNode.h"
#import "STKFriend.h"
#import "STKAvatar.h"

@interface STKLobbyPersonNode()

@end

@implementation STKLobbyPersonNode

+ (STKLobbyPersonNode *)newLobbyPersonNodeWithFriend:(STKFriend *)friend
{
	STKLobbyPersonNode *lobbyNode = (STKLobbyPersonNode *)[CCBReader load:@"Lobby Scene/LobbyPersonNode.ccbi"];
	lobbyNode.friend = friend;
	
	return lobbyNode;
}

- (void)setFriend:(STKFriend *)friend
{
	if(_friend)
	{
		[self removeAsObserverForModel:_friend];
	}
	
	_friend = friend;
	
	if(friend)
	{
		[self observeModel:friend];
	}
}

#pragma mark model listening
- (void)friend:(STKFriend *)friend valueChangedForIsOnline:(NSNumber *)isOnline
{
	[self updatePlayerStatus];
}

- (void)friend:(STKFriend *)friend valueChangedForIsInMatch:(NSNumber *)isInMatch
{
	[self updatePlayerStatus];
}

- (void)updatePlayerStatus
{
	// Set ring colors
	if(self.friend.isOnline && self.friend.isInMatch)
	{
		self.avatarNode.borderColor = PLAYER_BUSY_COLOR;
		self.avatarNode.backgroundColor = PLAYER_BUSY_COLOR;
	}
	else if(self.friend.isOnline)
	{
		self.avatarNode.borderColor = PLAYER_ONLINE_COLOR;
		self.avatarNode.backgroundColor = PLAYER_ONLINE_COLOR;
	}
	else
	{
		self.avatarNode.borderColor = PLAYER_OFFLINE_COLOR;
		self.avatarNode.backgroundColor = PLAYER_OFFLINE_COLOR;
	}
	
	// Change icon based on status
	if(self.friend.isPlayer)
	{
		// Remove icon (cant challenge)
		if(!self.friend.isOnline || self.friend.isInMatch)
		{
			self.icon.opacity = 0;
		}
		// Challenge icon
		else
		{
			self.icon.opacity = 1;
			self.icon.texture = [CCTexture textureWithFile:@"Lobby Scene/arrow-icon.png"];
		}
	}
	// Invite icon
	else
	{
		self.icon.opacity = 1;
		self.icon.texture = [CCTexture textureWithFile:@"Lobby Scene/plus-icon.png"];
	}
}

- (void)friend:(STKFriend *)friend valueChangedForAvatar:(STKAvatar *)avatar
{
	self.avatarNode.avatar = friend.avatar;
}

- (void)friend:(STKFriend *)friend valueChangedForName:(NSString *)name
{
	// We have both, so we can set both labels
	if(friend.name && friend.fullName)
	{
		self.playerNameLabel.string = friend.name;
		self.realNameLabel.string = friend.fullName;
	}
	// There is only one, removing the smallest label and centering it
	else
	{
		// Removing the smaller label
		[self.realNameLabel removeFromParent];
		
		// Centering the bigger label
		self.playerNameLabel.position = CGPointMake(self.playerNameLabel.position.x, self.playerNameLabel.position.y - 9);
		
		// Setting the correct text of bigger label
		if(friend.fullName)
		{
			self.playerNameLabel.string = friend.fullName;
		}
		else
		{
			self.playerNameLabel.string = friend.name;
		}
	}
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<LobbyPersonNode> for %@", self.friend];
}

@end
