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

- (id)initWithID:(int8_t)playerId andPlayer:(STKPlayer*)player
{
    self = [super init];
    if(self)
    {
        self.playerId = playerId;
        self.info = player;
    }
    return self;
}

@end
