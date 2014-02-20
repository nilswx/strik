//
//  STKMatch.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/22/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKMatch.h"
#import "STKMatchPlayer.h"
#import "STKTile.h"
#import "STKBoard.h"

@implementation STKMatch

- (STKMatchPlayer *)playerByID:(int)ID
{
	if(ID == self.player.playerId)
	{
		return self.player;
	}
	else if(ID == self.opponent.playerId)
	{
		return self.opponent;
	}
	else
	{
		return nil;
	}
}

- (BOOL)isPlayer:(int)ID
{
	return self.player.playerId == ID;
}

@end
