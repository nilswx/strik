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
#import "STKExperience.h"

@implementation STKPlayer

- (void)setXp:(int)xp
{
	if(self.level)
	{
		// Level up...
		while(xp >= self.level.next.beginXP)
		{
			self.level = self.level.next;
		}
	}
	else
	{
		// Initial fetch
		self.level = [STKExperience levelForXP:xp];
	}
	
	_xp = xp;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<Actor %d - %@>", self.playerId, self.name];
}

+ (STKPlayer*)playerFromMessage:(STKIncomingMessage *)msg
{
	STKPlayer* user = [[STKPlayer alloc] init];
	user.playerId = [msg readInt];
	user.name = [msg readStr];
	user.avatar = [STKAvatar avatarWithIdentifier:[msg readStr]];
	user.country = [msg readStr];
	user.xp = [msg readInt];
	user.matches = [msg readInt];
	user.wins = [msg readInt];
	user.losses = [msg readInt];
	
	return user;
}


@end