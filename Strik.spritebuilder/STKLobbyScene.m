//
//  STKLobbyScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLobbyScene.h"
#import "GridNode.h"

@interface STKLobbyScene()

// The container where the friends and none friends will be shown
@property CCNode *peepsContainer;

// This node hold the "no friends" info. Remove it when needed
@property CCNode *noFriendsContainer;

@end

@implementation STKLobbyScene

- (void)showFriends
{
	// First remove the no friends container
	[self.noFriendsContainer removeFromParent];
	
	// And show the friends
	self.friendsGridNode = [GridNode gridWithDataSource:self.controller];
	self.friendsGridNode.contentSizeType = CCSizeTypeNormalized;
	self.friendsGridNode.contentSize = CGSizeMake(1, 1);
	
	[self.peepsContainer addChild:self.friendsGridNode];
}

@end
