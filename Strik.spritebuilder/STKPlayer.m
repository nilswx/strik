//
//  STKUser.m
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKPlayer.h"

#import "STKIncomingMessage.h"
#import "STKAvatar.h"
#import "STKProgression.h"

@implementation STKPlayer

+ (STKPlayer*)playerFromMessage:(STKIncomingMessage *)msg
{
	STKPlayer* user = [[STKPlayer alloc] init];
	user.playerId = [msg readInt];
	user.name = [msg readStr];
	user.avatar = [STKAvatar avatarWithIdentifier:[msg readStr]];
	user.motto = [msg readStr];
	user.country = [msg readStr];

    int xp = [msg readInt];
    user.progression = [STKProgression new];
	user.progression.xp = xp;

	user.matches = [msg readInt];
	user.wins = [msg readInt];
	user.losses = [msg readInt];
	
	return user;
}

@end