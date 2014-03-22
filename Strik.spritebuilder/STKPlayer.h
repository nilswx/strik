//
//  STKUser.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

#import "STKIncomingMessage.h"

@class STKAvatar;
@class STKProgression;
@class STKLevel;

@interface STKPlayer : STKModel

// Identity
@property int playerId;

// Customizable
@property NSString *name;
@property STKAvatar *avatar;
@property NSString *country;

// Statistics
@property(nonatomic) int xp;
@property STKLevel* level;
@property int matches;
@property int wins;
@property int losses;

+ (STKPlayer*)playerFromMessage:(STKIncomingMessage*)msg;

@end