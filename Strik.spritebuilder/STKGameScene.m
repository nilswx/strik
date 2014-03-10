//
//  STKGameScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKGameScene.h"

#import "STKAvatarNode.h"
#import "STKLevelNode.h"

#import "STKMatch.h"

#import "STKMatchPlayer.h"
#import "STKPLayer.h"

@interface STKGameScene()

// Player one
@property CCLabelTTF *playerOneLabel;
@property STKAvatarNode *playerOneAvatar;
@property STKLevelNode *playerOneScore;

// Player two
@property CCLabelTTF *playerTwoLabel;
@property STKAvatarNode *playerTwoAvatar;
@property STKLevelNode *playerTwoScore;

// Timeline
@property CCNodeColor *timelineContainer;
@property CCNodeColor *timeline;
@property CCLabelTTF *timelineLabel;

@end

@implementation STKGameScene

#pragma mark Model changes
- (void)match:(STKMatch *)match valueChangedForPlayer:(STKMatchPlayer *)player
{
	// Setup player one
	self.playerOneLabel.string = player.user.name;
	
	self.playerOneAvatar.backgroundColor = PLAYER_ONE_COLOR;
	self.playerOneAvatar.borderColor = PLAYER_ONE_COLOR;
	self.playerOneAvatar.avatar = player.user.avatar;
	
	self.playerOneScore.backgroundColor = PLAYER_ONE_COLOR;
	self.playerOneScore.fontColor = [CCColor whiteColor];
	self.playerOneScore.text = @"0";
}

- (void)match:(STKMatch *)match valueChangedForOpponent:(STKMatchPlayer *)oppponent
{
	// Setup player two
	self.playerTwoLabel.string = oppponent.user.name;
	
	self.playerTwoAvatar.backgroundColor = PLAYER_TWO_COLOR;
	self.playerTwoAvatar.borderColor = PLAYER_TWO_COLOR;
	self.playerTwoAvatar.avatar = oppponent.user.avatar;
	
	self.playerTwoScore.backgroundColor = PLAYER_TWO_COLOR;
	self.playerTwoScore.fontColor = [CCColor whiteColor];
	self.playerTwoScore.text = @"0";
}

@end
