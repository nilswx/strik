//
//  STKTrophy.m
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKTrophy.h"

@implementation STKTrophy

+ (STKTrophy*)trophyWithID:(int)typeId andCode:(NSString*)code
{
	return [[STKTrophy alloc] initWithID:typeId andCode:code];
}

@end
