//
//  STKAvatarPickerScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAvatarPickerScene.h"
#import "PagedScrollNode.h"

@implementation STKAvatarPickerScene

- (void)onEnterTransitionDidFinish
{
	// Create the paged scroll node for the avatar picker
	self.avatarPagedScrollNode = [PagedScrollNode pagedScrollNodeWithDataSource:self.controller];
	self.avatarPagedScrollNode.contentSizeType = CCSizeTypeNormalized;
	self.avatarPagedScrollNode.contentSize = CGSizeMake(1, 1);
	
	[self.avatarPickerContainer addChild:self.avatarPagedScrollNode];
}

@end
