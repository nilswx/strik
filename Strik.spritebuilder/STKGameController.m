//
//  STKGameController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKGameController.h"
#import "STKGameScene.h"

#import "STKMatchController.h"

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
	
}

#pragma mark user events

@end
