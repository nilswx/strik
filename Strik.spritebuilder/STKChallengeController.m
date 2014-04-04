//
//  STKChallengeController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 31/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKChallengeController.h"

#import "STKLobbyController.h"
#import "STKDirector.h"

@implementation STKChallengeController

- (void)onCancelButton:(CCButton *)sender
{
	STKDirector *director = self.core[@"director"];
	STKLobbyController *lobbyController = (STKLobbyController *)(director.sceneController);
	[lobbyController revokeChallenge];
}

@end
