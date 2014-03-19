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

// This node will be place at the bottom of the screen behind the table @ 50% height, so when the last item color is blue-ish, it doesnt end @ scrolling bottom
@property CCNodeColor *bottomColorNode;

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
	
	// Create grid node
	self.friendsGridNode = [GridNode gridWithDataSource:self.controller];
	self.friendsGridNode.contentSizeType = CCSizeTypeNormalized;
	self.friendsGridNode.contentSize = CGSizeMake(1, 1);
	self.friendsGridNode.delegate = self.controller;
	
	// Add to scene
	[self.peepsContainer addChild:self.friendsGridNode];
}

- (void)showBottom
{
	self.bottomColorNode.opacity = 1;
}

- (void)hideBottom
{
	self.bottomColorNode.opacity = 0;
}

- (void)scrollUp
{
	if(self.friendsGridNode)
	{
		[self.friendsGridNode.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
	}
}

@end
