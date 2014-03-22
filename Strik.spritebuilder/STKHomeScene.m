//
//  STKHomeScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKHomeScene.h"

#import "STKAvatarNode.h"
#import "STKLevelNode.h"
#import "STKProgressNode.h"
#import "STKPlayer.h"
#import "STKAvatar.h"
#import "STKExperience.h"

@interface STKHomeScene()

// The username button / label
@property CCButton *username;

// The user avatar
@property STKAvatarNode *avatarNode;

// The user levelecl
@property STKLevelNode *levelNode;

// The user progress bar
@property STKProgressNode *playerProgress;

// The timeline will be placed in here
@property CCNode *timeLineContainer;

@end

@implementation STKHomeScene

- (void)sceneLoaded
{
	// Setting up the progress bar
	self.playerProgress.borderColor = [CCColor whiteColor];
	self.playerProgress.backgroundShade = PLAYER_ONE_LIGHT_COLOR;
	self.playerProgress.fillShade = PLAYER_ONE_COLOR;
}

#pragma mark Model events

- (void)player:(STKPlayer*)player valueChangedForXp:(NSNumber*)xp
{
	// Get latest level
	STKLevel* level = player.level;
	
	// Update progress
	[self.playerProgress setValue:[level progressToNext:player.xp] ofTotalValue:level.totalToNext animated:YES];
	
	// Update level
	self.levelNode.backgroundColor = [CCColor whiteColor];
	self.levelNode.fontColor = PLAYER_ONE_COLOR;
	self.levelNode.text = [NSString stringWithFormat:@"%d", level.num];
}

- (void)player:(STKPlayer *)player valueChangedForName:(NSString *)name
{
	self.username.title = name;
}

- (void)player:(STKPlayer *)player valueChangedForAvatar:(STKAvatar *)avatar
{
	// Setting up the avatar
	self.avatarNode.borderColor = [CCColor whiteColor];
	self.avatarNode.backgroundColor = PLAYER_ONE_COLOR;
	
	self.avatarNode.avatar = avatar;
}

- (void)dealloc
{
	
}

@end
