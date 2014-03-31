//
//  STKMatchController.h
//  Strik
//
//  Created by Matthijn Dijkstra on 10/22/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKController.h"

@class STKMatch;

@interface STKMatchController : STKController

@property(nonatomic) STKMatch *match;

- (void)requestNewMatch;
- (void)playerIsReady;
- (void)exitMatch;
- (void)clearMatch;


// Accept a challenge if one is there (it will send the server request regardless)
- (void)acceptedChallengeForFriend:(int)playerId accepted:(BOOL)acceptedChallenge;

@end
