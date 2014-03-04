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

#import "STKAvatarPage.h"
#import "STKAvatar.h"
#import "STKAvatarNode.h"

#import "STKButton.h"

#import "STKSessionController.h"
#import "STKPLayer.h"

#import "STKDirector.h"
#import "STKDirector+Modal.h"

@interface STKAvatarPickerController()

@property PagedScrollNode *pagedScrollNode;

@property (readonly) STKAvatarPickerScene *avatarPickerScene;

// Contains all avatars, first item is facebook avatar
@property NSArray *allAvatars;

@end

@implementation STKAvatarPickerController

- (void)sceneCreated
{
	// Load all available avatars in an array
	[self loadAvatars];
}

- (void)loadAvatars
{
	NSMutableArray *avatars = [NSMutableArray array];

	// The user avatar (e.g the facebook profile, or a default facebook picture)
	
	// The client avatars
	for(int i =  1; i <= CLIENT_AVATAR_COUNT; i++)
	{
		STKAvatar *avatar = [STKAvatar avatarWithIdentifier:[NSString stringWithFormat:@"%d", i]];
		[avatars addObject:avatar];
	}
	
	self.allAvatars = [NSArray arrayWithArray:avatars];
}

#pragma mark PagedSCrollNodeDataSource
- (int)numberOfPages
{
	// The plus one is for the facebook avatar
	int numberOfPages = ceil((float)(CLIENT_AVATAR_COUNT + 1) / (float)[STKAvatarPage avatarsPerPage]);
	return numberOfPages;
}

- (CCNode *)nodeForPage:(int)page
{
	// Get the avatars for this page
	NSArray *avatarsForPage = [self avatarsForPage:page];
	
	// Create a page with these avatars
	STKAvatarPage *avatarPage = [STKAvatarPage avatarPageWithAvatars:avatarsForPage];
	avatarPage.controller = self;
	
	return avatarPage;
}

- (NSArray *)avatarsForPage:(int)page
{
	// Determine range for page
	int start = page * [STKAvatarPage avatarsPerPage];
	int length = MIN(self.allAvatars.count - start, [STKAvatarPage avatarsPerPage]);
	
	NSRange avatarRange = NSMakeRange(start, length);
	
	// Return range for page
	return [self.allAvatars subarrayWithRange:avatarRange];
}

- (CGSize)pageSize
{
	return CGSizeMake(295, 385);
}

- (STKAvatarPickerScene *)avatarPickerScene
{
	return self.scene;
}

#pragma mark events
- (void)onAvatarNodeButton:(STKButton *)button
{
	STKAvatarNode *avatarNode = button.data;
	
	STKSessionController *sessionController = self.core[@"session"];
	sessionController.user.avatar.identifier = avatarNode.avatar.identifier;
	
	STKDirector *director = self.core[@"director"];
	[director hideOverlay];
}

@end
