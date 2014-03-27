//
//  STKNewsCache.m
//  Strik
//
//  Created by Nils Wiersema on Mar 27, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKNewsCache.h"

#import "STKNewsItem.h"
#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"

@implementation STKNewsCache

- (void)componentDidInstall
{
	[self routeNetMessagesOf:NEWS to:@selector(handleNews:)];
}

- (void)refreshNews
{
	NSLog(@"News: requesting news...");
	
	[self sendNetMessage:[STKOutgoingMessage withOp:GET_NEWS]];
}

- (void)handleNews:(STKIncomingMessage*)msg
{
	// How many items are we expecting?
	int amount = [msg readInt];
	NSMutableArray* items = [NSMutableArray arrayWithCapacity:amount];
	
	// Process new ones
	for(int i = 0; i < amount; i++)
	{
		STKNewsItem* item = [STKNewsItem new];
		item.id = [msg readInt];
		item.headline = [msg readStr];
		item.timestamp = [NSDate dateWithTimeIntervalSince1970:[msg readInt]];
		item.imageUrl = [msg readStr];
		item.body = [msg readStr];
		[items addObject:item];
	}
	self->_items = items;
	
	NSLog(@"News: received and cached %d items!", items.count);
}

@end
