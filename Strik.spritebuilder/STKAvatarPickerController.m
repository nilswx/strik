//
//  STKAvatarPickerController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAvatarPickerController.h"
#import "STKAVatarPickerScene.h"

#import "PagedScrollNode.h"

@interface STKAvatarPickerController()

@property PagedScrollNode *pagedScrollNode;

@property (readonly) STKAvatarPickerScene *avatarPickerScene;

@end

@implementation STKAvatarPickerController

- (void)sceneCreated
{
	// Create the paged scroll node for the avatar picker
	self.pagedScrollNode = [PagedScrollNode pagedScrollNodeWithDataSource:self];
	self.pagedScrollNode.contentSizeType = CCSizeTypeNormalized;
	self.pagedScrollNode.contentSize = CGSizeMake(1, 1);
	
	[self.avatarPickerScene.avatarPickerContainer addChild:self.pagedScrollNode];
}

#pragma mark PagedSCrollNodeDataSource
- (int)numberOfPages
{
	return 3;
}

- (CCNode *)nodeForPage:(int)page
{
	CCNodeColor *node;
	if(page == 0)
	{
		node = [CCNodeColor nodeWithColor:[CCColor redColor]];
	}
	else if(page == 1)
	{
		node = [CCNodeColor nodeWithColor:[CCColor purpleColor]];
	}
	else
	{
		node = [CCNodeColor nodeWithColor:[CCColor greenColor]];
	}
	
	node.contentSizeType = CCSizeTypePoints;
	node.contentSize = self.pageSize;
	
	return node;
}

- (CGSize)pageSize
{
	return CGSizeMake(295, 385);
}

- (STKAvatarPickerScene *)avatarPickerScene
{
	return self.scene;
}

@end
