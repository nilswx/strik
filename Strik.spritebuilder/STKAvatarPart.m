//
//  STKAvatarPart.m
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKAvatarPart.h"

@implementation STKAvatarPart

+ (STKAvatarPart*)partWithID:(int)typeId code:(NSString*)code andSlot:(STKAvatarPartSlot)slot
{
	STKAvatarPart* part = [[STKAvatarPart alloc] initWithID:typeId andCode:code];
	part->_slot = slot;
	
	return part;
}

@end
