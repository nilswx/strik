//
//  STKEndGameController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 18/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKEndGameController.h"
#import "STKEndGameScene.h"

#import "STKMatchPlayer.h"
#import "STKPLayer.h"
#import "STKMatch.h"

#import "STKMatchController.h"

#import "STKAvatarNode.h"

@interface STKEndGameController()

// For convenience
@property (nonatomic, readonly) STKEndGameScene *endGameScene;
@property (nonatomic, readonly) STKMatch *match;

@end

@implementation STKEndGameController

- (void)sceneWillBegin
{
	// Setup the player information
	[self setupPlayers];
}

- (void)setupPlayers
{
	// Player one
	STKAvatarNode *pOneAvatar = self.endGameScene.playerOneAvatar;
	STKPlayer *player = self.match.player.info;

	pOneAvatar.borderColor = PLAYER_ONE_COLOR;
	pOneAvatar.backgroundColor = PLAYER_ONE_COLOR;
	pOneAvatar.avatar = player.avatar;

	self.endGameScene.playerOneLabel.string = player.name;
	
	// Player two
	STKAvatarNode *pTwoAvatar = self.endGameScene.playerTwoAvatar;
	STKPlayer *opponent = self.match.opponent.info;
	
	pTwoAvatar.borderColor = PLAYER_TWO_COLOR;
	pTwoAvatar.backgroundColor = PLAYER_TWO_COLOR;
	pTwoAvatar.avatar = opponent.avatar;
}

#pragma mark User interaction
- (void)onCloseButton:(CCButton *)button
{
	NSLog(@"Close please");
}

- (void)onRematchButton:(CCButton *)button
{
	NSLog(@"Rematch please");
}

- (STKEndGameScene *)endGameScene
{
	return self.scene;
}

- (STKMatch *)match
{
	return ((STKMatchController *)(self.core[@"match"])).match;
}

- (void)dealloc
{
	// Clear up the match when leaving this scene
	((STKMatchController *)(self.core[@"match"])).match = nil;
}

@end
