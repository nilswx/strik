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
#import "STKFacebookController.h"
#import "STKPLayer.h"

#import "STKDirector.h"
#import "STKDirector+Modal.h"

#import "STKAlertView.h"

#import "STKOutgoingMessage.h"

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

	STKFacebookController *facebookController = self.core[@"facebook"];

	// Use the avatar based on facebook linked status (e.g default FB image, or profile picture)
	STKAvatar *facebookAvatar;
	
	// Determine if the user if facebook linked
	if(!facebookController.isServerLinked)
	{
		// Use default avatar
		facebookAvatar = [STKAvatar avatarWithIdentifier:AVATAR_TYPE_NO_FACEBOOK_ID];
	}
	else
	{
		// Use profile image
		STKSessionController *sessionController = self.core[@"session"];
		NSString *facebookIdentifier = [NSString stringWithFormat:@"f%d", sessionController.user.playerId];
		facebookAvatar = [STKAvatar avatarWithIdentifier:facebookIdentifier];
	}
	
	// Ad facebook avatar as first image to array
	[avatars addObject:facebookAvatar];
	
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

	if(avatarNode.avatar.avatarType == AvatarTypeNoFacebook)
	{
		STKAlertView *alert = [STKAlertView confirmationWithTitle:NSLocalizedString(@"Connect Facebook", @"Connect facebook alert title") message:NSLocalizedString(@"Connect with Facebook to use your own photo as a profile picture. Would you like to do this now?", nil) target:self yesSelector:@selector(onFacebookConnectYes:) andNoSelector:@selector(onFacebookConnectNo:)];
		[alert show];
	}
	else
	{
		avatarNode.borderColor = AVATAR_ACTIVE_BORDER_COLOR;

		// Set network message of changed avatar
		STKOutgoingMessage *message = [[STKOutgoingMessage alloc] initWithOp:AVATAR_CHANGED];
		if(avatarNode.avatar.avatarType == AvatarTypeProfile)
		{
			[message appendStr:@"f"];
		}
		else
		{
			[message appendStr:avatarNode.avatar.identifier];
		}

		[self sendNetMessage:message];
		
		STKDirector *director = self.core[@"director"];
		[director hideOverlay];
	}
}
							   
- (void)onFacebookConnectYes:(id)sender
{
	NSLog(@"Sweetness! Connect with facebook please.");
}

- (void)onFacebookConnectNo:(id)sender
{
	NSLog(@"Well, I'm not feeling like connecting right now.");
}

- (STKAvatar *)currentAvatar
{
	STKSessionController *sessionController = self.core[@"session"];
	return sessionController.user.avatar;
}

// Returns the page a given avatar can be found
- (int)pageForAvatar:(STKAvatar *)avatar
{
	// Determine if the avatar is in the client list (else it returns the first page)
	int index = 0;
	if([self.allAvatars containsObject:avatar])
	{
		index = [self.allAvatars indexOfObject:avatar];
	}
	
	return floor(index / [STKAvatarPage avatarsPerPage]);
}

@end
