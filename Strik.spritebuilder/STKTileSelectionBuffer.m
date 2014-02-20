//
//  STKTileSelectionBuffer.m
//  Strik
//
//  Created by Nils on Sep 30, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKTileSelectionBuffer.h"

#import "STKTile.h"
#import "STKOutgoingMessage.h"

@interface STKTileSelectionBuffer()

@property NSMutableArray* selected;

@end

@implementation STKTileSelectionBuffer

- (id)init
{
	if(self = [super init])
	{
		// Replace with a STKOutgoingMessage and serialize every tile as it's added?
		self.selected = [NSMutableArray arrayWithCapacity:16];
	}
	
	return self;
}

- (void)beginBuffer
{
	self->_isOpen = YES;
	[self startFlushTimeout];
}

- (void)addTile:(STKTile*)tile
{
	if(!self.isOpen)
	{
		[self beginBuffer];
	}
	[self.selected addObject:tile];
}

- (void)endBuffer
{
	if(self.isOpen)
	{
		self->_isOpen = NO;
		[self flushToServerAndCompleteSelection:YES];
	}
}

- (void)flushToServerAndCompleteSelection:(BOOL)completeSelection
{
	// Needs to flush?
	if(completeSelection || self.selected.count > 0)
	{
		// Process updates into a message
		STKOutgoingMessage* msg = [STKOutgoingMessage withOp:UPDATE_TILE_SELECTION];
		[msg appendByte:self.selected.count];
		for(STKTile* tile in self.selected)
		{
			[msg appendByte:tile.tileId];
		}
		[msg appendBool:completeSelection];
		[self.selected removeAllObjects];
		
		// Send message
		[self sendNetMessage:msg];
	}
}

- (void)startFlushTimeout
{
	[self performSelector:@selector(flushTimeout) withObject:nil afterDelay:0.100];
}

- (void)flushTimeout
{
	[self flushToServerAndCompleteSelection:NO];
	if(self.isOpen)
	{
		[self startFlushTimeout];
	}
}

@end
