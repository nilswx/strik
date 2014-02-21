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

#import "STKPLayer.h"

@interface STKHomeScene()

// The username button / label
@property CCButton *username;

// The user avatar
@property STKAvatarNode *avatar;

// The user level
@property STKLevelNode *levelNode;

@end

@implementation STKHomeScene

- (void)sceneWillBegin
{
	self.avatar.borderColor = [CCColor whiteColor];
	self.avatar.backgroundColor = [CCColor redColor];
	self.avatar.maskedImage = [CCSprite spriteWithImageNamed:@"Home Scene/valerie.png"];
}

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

@end
