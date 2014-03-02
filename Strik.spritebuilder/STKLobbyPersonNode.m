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
	_friend = friend;
	
	if(friend)
	{
		
		// Todo: check for reaallly long names
		
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
		
		// Set ring colors
		if(friend.isOnline && friend.isInMatch)
		{
			self.avatarNode.borderColor = PLAYER_BUSY_COLOR;
		}
		else if(friend.isOnline)
		{
			self.avatarNode.borderColor = PLAYER_ONLINE_COLOR;
		}
		else
		{
			self.avatarNode.borderColor = PLAYER_OFFLINE_COLOR;
		}
		
		// Load avatar image
		[friend.avatar fetchAvatarWithCallback:^(CCTexture *avatarTexture, AvatarType avatarType) {
			[self.avatarNode setAvatarTexture:avatarTexture ofType:avatarType];
		}];
		
	}
}

@end
