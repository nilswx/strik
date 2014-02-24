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

@end

@implementation STKLobbyScene


- (void)sceneWillBegin
{
	self.friendsGridNode = [GridNode gridWithDataSource:self.controller];
	self.friendsGridNode.contentSizeType = CCSizeTypeNormalized;
	self.friendsGridNode.contentSize = CGSizeMake(1, 1);
	
	[self.peepsContainer addChild:self.friendsGridNode];
}

@end
