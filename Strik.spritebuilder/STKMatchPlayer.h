//
//  STKPlayer.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

@class STKPlayer;

@interface STKMatchPlayer : STKModel

@property int playerId;
@property STKPlayer* user;
@property int score;

- (id)initWithID:(int8_t)playerId andUser:(STKPlayer*)user;
+ (STKMatchPlayer*)player:(int8_t)playerId withUser:(STKPlayer*)user;

@end

typedef NS_ENUM(char, Player)
{
	ONE,
	TWO
};