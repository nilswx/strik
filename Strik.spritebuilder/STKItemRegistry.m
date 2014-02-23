//
//  STKItemTypeRegistry.m
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKItemRegistry.h"

#import "STKItemType.h"
#import "STKIncomingMessage.h"

#import "STKItemType.h"
#import "STKTrophy.h"
#import "STKPowerUp.h"

@interface STKItemRegistry()

@property NSMutableDictionary* types;

@end

@implementation STKItemRegistry

static STKItemRegistry* instance;

- (void)componentDidInstall
{
	self.types = [NSMutableDictionary dictionary];
	
	instance = self;
	
	[self routeNetMessagesOf:ITEM_TYPES to:@selector(handleItemTypes:)];
}

- (void)addType:(STKItemType*)type
{
	STKItemType* other = [self typeForID:type.typeId];
	if(other)
	{
		NSLog(@"ItemRegistry: #%d \"%@\" cannot use the same ID as #%d \"%@\"!",
			  type.typeId, type.code,
			  other.typeId, other.code);
	}
	else if((other = [self typeForCode:type.code]))
	{
		NSLog(@"ItemRegistry: #%d \"%@\" cannot use the same code as #%d \"%@\"!",
			  type.typeId, type.code,
			  other.typeId, other.code);
	}
	else
	{
		self.types[@(type.typeId)] = type;
		self.types[type.code] = type;
		
		NSLog(@"ItemRegistry: added #%d \"%@\" [%@]",
			  type.typeId, type.code, NSStringFromClass([type class]));
	}
}

- (STKItemType*)typeForID:(int)typeId
{
	return self.types[@(typeId)];
}

- (STKItemType*)typeForCode:(NSString*)code
{
	return self.types[code];
}

- (void)handleItemTypes:(STKIncomingMessage*)msg
{
	[self.types removeAllObjects];
	
	int amount = [msg readInt];
	for(int i = 0; i < amount; i++)
	{
		int typeId = [msg readInt];
		NSString* code = [msg readStr];
		char class = [msg readByte];
		
		if(class == 't')
		{
			[self addType:[STKTrophy trophyWithID:typeId andCode:code]];
		}
		else if(class == 'p')
		{
			[self addType:[STKPowerUp powerUpWithID:typeId andCode:code]];
		}
		else if(class == 'a')
		{
			#pragma mark remove me
			char slot = [msg readByte];
//			[self addType:[STKAvatarPart partWithID:typeId code:code andSlot:slot]];
		}
	}
	
	NSLog(@"ItemRegistry: received %d types from server", amount);
}

+ (STKItemRegistry*)sharedRegistry
{
	return instance;
}

@end
