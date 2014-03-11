//
//  STKGameController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKGameController.h"

#import "STKGameScene.h"
#import "STKMatchPlayer.h"
#import "STKMatch.h"
#import "STKPLayer.h"
#import "STKMatchController.h"
#import "STKIncomingMessage.h"

#import "NSObject+Observer.h"

@interface STKGameController()

@property STKMatchController *matchController;

@end

@implementation STKGameController

- (void)sceneCreated
{
    // Create a pointer to the matchController to have easier accces
    self.matchController = self.core[@"match"];
    
	// Set match for scene so it can listen to changes
    STKGameScene *gameScene = self.scene;
    gameScene.match = self.matchController.match;
	
    // Network events
	[self routeNetMessagesOf:BOARD_INIT to:@selector(setupBoard:)];
    [self routeNetMessagesOf:BOARD_UPDATE to:@selector(handleBoardUpdates:)];
    [self routeNetMessagesOf:WORD_FOUND to:@selector(handleWordFound:)];
}

#pragma mark networking
- (void)setupBoard:(STKIncomingMessage *)message
{
	
}

- (void)handleBoardUpdates:(STKIncomingMessage *)message
{
	
}

- (void)handleWordFound:(STKIncomingMessage *)message
{
	// Retrieve player that found the word
	STKMatch* match = self.matchController.match;
	STKMatchPlayer* player = [match playerByID:[message readByte]];
	
	// Parse the found word & score
	NSString* word = [message readStr];
	int points = [message readInt];
	
	// TODO: read the tile IDs, animate tiles into word, play sound, etc etc
	NSLog(@"MatchGameScene: %@ found %@ (%d points)", player.info.name, word, points);
	
	// Boost the score
	player.score += points;
}

#pragma mark user events

@end
