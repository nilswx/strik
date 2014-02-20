//
//  STKPlayer.m
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKMatchPlayer.h"
#import "STKPlayer.h"

@implementation STKMatchPlayer

- (id)initWithID:(int8_t)playerId andUser:(STKPlayer*)user
{
    self = [super init];
    if(self)
    {
        self.playerId = playerId;
        self.user = user;
    }
    return self;
}

+ (STKMatchPlayer*)player:(int8_t)playerId withUser:(STKPlayer*)user
{
    return [[STKMatchPlayer alloc] initWithID:playerId andUser:user];
}

@end
