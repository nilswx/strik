//
//  STKTile.m
//  Strik
//
//  Created by Matthijn on Oct 23, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKTile.h"
#import "STKBoard.h"
#import "STKMatchPlayer.h"

@interface STKTile()

@property (nonatomic, assign) char selectedBy;

@end

@implementation STKTile

- (id)initWithBoard:(STKBoard *)board column:(int)column andTileId:(SInt8)tileId
{
    self = [super init];
    if(self)
    {
		self->_board = board;
		self->_tileId = tileId;
		self->_column = column;
    }
    return self;
}

+ (id)tileForBoard:(STKBoard *)board column:(int)column andTileId:(SInt8)tileId
{
    return [[STKTile alloc] initWithBoard:board column:column andTileId:tileId];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<STKTile %d - %c (%d,%d)>", self.tileId, self.letter, self.position.column, self.position.row];
}

- (STKTilePosition)position
{
	STKTilePosition position;
	position.column = self.column;
	position.row = self.row;
	return position;
}

- (int)row
{
	return [self.board rowForTile:self];
}

- (void)selectFor:(STKMatchPlayer*)player
{
	if(![self isSelectedBy:player])
	{
		self.selectedBy |= (1 << player.playerId);
	}
}

- (void)deselectFor:(STKMatchPlayer*)player
{
	if([self isSelectedBy:player])
	{
		self.selectedBy &= ~(1 << player.playerId);
	}
}

- (BOOL)isSelectedBy:(STKMatchPlayer*)player
{
	return (self.selectedBy & (1 << player.playerId));
}

@end
