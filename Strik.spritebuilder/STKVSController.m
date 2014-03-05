//
//  STKVSSceneController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKVSController.h"

#import "STKVSScene.h"
#import "STKVSCard.h"

#import "STKAvatarNode.h"
#import "STKProgressNode.h"
#import "STKLevelNode.h"

#import "STKSessionController.h"

#import "STKPLayer.h"
#import "STKProgression.h"

@interface STKVSController()

@property (readonly) STKVSScene *vsScene;

@end

@implementation STKVSController

- (void)sceneCreated
{
	[self setupPlayerOne];
}

- (void)setupPlayerOne
{
	STKSessionController *sessionController = self.core[@"session"];
	
	STKPlayer *playerOne = sessionController.user;
	
	// Setup player one
	STKVSCard *playerOneCard = self.vsScene.playerOneCard;
	
	// The name
	playerOneCard.nameLabel.string = playerOne.name;
	
	// The avatar
	playerOneCard.avatarNode.borderColor = PLAYER_ONE_COLOR;
	playerOneCard.avatarNode.backgroundColor = PLAYER_ONE_COLOR;
	playerOneCard.avatarNode.avatar = playerOne.avatar;
	
	// Progress
	// Todo: get actual value
	playerOneCard.progressNode.lightShade = PLAYER_ONE_LIGHT_COLOR;
	playerOneCard.progressNode.darkShade = PLAYER_ONE_COLOR;
	[playerOneCard.progressNode setValue:930 ofTotalValue:1500];
	
	// Level
	playerOneCard.levelNode.backgroundColor = PLAYER_ONE_COLOR;
	playerOneCard.levelNode.fontColor = [CCColor whiteColor];
	playerOneCard.levelNode.text = [NSString stringWithFormat:@"%d", playerOne.progression.level];
}

- (STKVSScene *)vsScene
{
	return self.scene;
}

@end
