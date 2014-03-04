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

- (void)onEnterTransitionDidFinish
{
	// Setting value of progress bar on transition completion, so it starts animating after it completes
	[self.playerProgress setValue:930 ofTotalValue:1500];
}

#pragma mark Model events
- (void)player:(STKPlayer *)player valueChangedForName:(NSString *)name
{
	self.username.title = name;
}

- (void)progression:(STKProgression *)progression valueChangedForLevel:(NSNumber*)level
{
	self.levelNode.backgroundColor = [CCColor whiteColor];
	
	self.levelNode.fontColor = PLAYER_ONE_COLOR;
	self.levelNode.text = [NSString stringWithFormat:@"%d", [level intValue]];
}

- (void)player:(STKPlayer *)player valueChangedForAvatar:(STKAvatar *)avatar
{
	// Setting up the avatar
	self.avatarNode.borderColor = [CCColor whiteColor];
	self.avatarNode.backgroundColor = PLAYER_ONE_COLOR;
	
	self.avatarNode.avatar = avatar;
}

@end
