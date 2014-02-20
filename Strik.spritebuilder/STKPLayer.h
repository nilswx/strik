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

@interface STKPlayer : STKModel

// Identity
@property(nonatomic) int playerId;

// Customizable
@property NSString *name;
@property STKAvatar *avatar;
@property NSString *motto;
@property NSString *country;

// Statistics
@property  STKProgression *progression;

@property int matches;
@property int wins;
@property int losses;

+ (STKPlayer*)playerFromMessage:(STKIncomingMessage*)msg;

@end