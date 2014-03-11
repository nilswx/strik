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
#import "STKPLayer.h"
#import "STKAvatar.h"
#import "STKProgression.h"

@interface STKHomeScene()

// The username button / label
@property CCButton *username;

// The user avatar
@property STKAvatarNode *avatarNode;

// The user level
@property STKLevelNode *levelNode;

// The user progress bar
@property STKProgressNode *playerProgress;

@end

@implementation STKHomeScene

- (void)sceneLoaded
{
	// Setting up the progress bar
	self.playerProgress.borderColor = [CCColor whiteColor];
	self.playerProgress.lightShade = PLAYER_ONE_LIGHT_COLOR;
	self.playerProgress.darkShade = PLAYER_ONE_COLOR;
}

#pragma mark Model events
- (void)progression:(STKProgression *)progression valueChangedForXp:(NSNumber *)xp
{
	// First set XP
	[self.playerProgress setValue:progression.xp ofTotalValue:progression.maxExperienceForLevel animated:YES];
	
	// Then level
	self.levelNode.backgroundColor = [CCColor whiteColor];
	
	self.levelNode.fontColor = PLAYER_ONE_COLOR;
	self.levelNode.text = [NSString stringWithFormat:@"%d", progression.level];
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

@end
