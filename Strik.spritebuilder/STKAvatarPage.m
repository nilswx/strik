//
//  STKAvatarPage.m
//  Strik
//
//  Created by Matthijn Dijkstra on 04/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAvatarPage.h"
#import "STKAvatar.h"
#import "STKAvatarNode.h"

#import "STKButton.h"

#define AVATAR_SCALE 0.78f
#define AVATAR_PADDING 8

#define TOP_PADDING 14
#define LEFT_PADDING 14

#define CONTAINER_SIZE 100

#import "STKAvatarPickerController.h"

@interface STKAvatarPage()

@property NSArray *avatars;

@property (readonly) STKAvatarPickerController *avatarController;

@end

@implementation STKAvatarPage

- (id)initWithAvatars:(NSArray *)avatars
{
	if(self = [super init])
	{
		self.avatars = avatars;
		
		self.contentSizeType = CCSizeTypeNormalized;
		self.contentSize = CGSizeMake(1, 1);
	}
	
	return self;
}

+ (id)avatarPageWithAvatars:(NSArray *)avatars
{
	return [[STKAvatarPage alloc] initWithAvatars:avatars];
}

- (void)onEnterTransitionDidFinish
{
	[super onEnter];
	[self layoutAvatars];
}

- (void)layoutAvatars
{
	int collumnCount = 3;
	
	// Todo: change it based on size of screen
	for(STKAvatar *avatar in self.avatars)
	{
		int index = [self.avatars indexOfObject:avatar];
		
		// Determine collumn and row for index
		int collumn = index % collumnCount;
		int row = floor((float)index / (float)collumnCount);
		
		// Get the avatar container node for this avatar
		CCNode *container = [self nodeForAvatar:avatar];
				
		// Position it
		
		container.position = [self positionForCollumn:collumn andRow:row];
		[self addChild:container];
	}
}

- (CCNode *)nodeForAvatar:(STKAvatar *)avatar
{
	CCNode *container = [CCNode node];

	// Set size and anchor point for container so we can position from top left
	container.contentSizeType = CCSizeTypePoints;
	container.contentSize = CGSizeMake(CONTAINER_SIZE, CONTAINER_SIZE);
	
	container.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerTopLeft);
	container.anchorPoint = CGPointMake(0, 1);
	
	// Scale it a bit down so there fit three nicely next to each other
	container.scale = AVATAR_SCALE;
	
	// Load the avatar and center in container
	STKAvatarNode *avatarNode = [STKAvatarNode new];
	avatarNode.position = CGPointMake(50, 50);

	avatarNode.backgroundColor = PLAYER_ONE_COLOR;
	
	if([avatar.identifier isEqualToString:self.avatarController.currentAvatar.identifier])
	{
		avatarNode.borderColor = AVATAR_ACTIVE_BORDER_COLOR;
	}
	else
	{
		avatarNode.borderColor = AVATAR_BORDER_COLOR;
	}

	avatarNode.avatar = avatar;
	
	
	// Add the avatar to the container
	[container addChild:avatarNode];
	
	// Create the button
	STKButton *button = [STKButton node];
	button.data = avatarNode;
	
	button.anchorPoint = CGPointMake(0, 0);
	button.position = CGPointMake(0, 0);
	
	button.preferredSizeType = CCSizeTypeNormalized;
	button.preferredSize = CGSizeMake(1, 1);
	
	[button setTarget:self.controller selector:@selector(onAvatarNodeButton:)];
	
	[container addChild:button];
	
	return container;
}

- (CGPoint)positionForCollumn:(int)collumn andRow:(int)row
{
	CGFloat fullAvatarWidth = (CONTAINER_SIZE * AVATAR_SCALE) + (2 * AVATAR_PADDING);
	CGFloat fullAvatarHeight = fullAvatarWidth;
	
	return CGPointMake((fullAvatarWidth * collumn) + LEFT_PADDING, (fullAvatarHeight * row) + TOP_PADDING);
}

- (STKAvatarPickerController *)avatarController
{
	return self.controller;
}

+ (int)avatarsPerPage
{
	// Todo: change this based on size of screen
	return 12;
}

@end
