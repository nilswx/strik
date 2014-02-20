//
//  STKAvatarPart.h
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKItemType.h"

typedef NS_ENUM(int8_t, STKAvatarPartSlot)
{
	HAT,
	HAIR,
	EYES,
	MOUTH,
	HEAD,
	BASE
};

@interface STKAvatarPart : STKItemType

@property(readonly) STKAvatarPartSlot slot;

+ (STKAvatarPart*)partWithID:(int)typeId code:(NSString*)code andSlot:(STKAvatarPartSlot)slot;

@end


