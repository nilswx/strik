//
//  STKSession.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKController.h"

@class STKPlayer;
@class STKInventory;

@interface STKSessionController : STKController

@property(nonatomic) long sessionId;
@property(nonatomic) NSString* server;

@property(nonatomic) STKPlayer* user;
@property(nonatomic) STKInventory* inventory;

- (void)createNewPlayer;

- (void)loginWithPlayerID:(int)playerId andToken:(NSString*)token;

@end