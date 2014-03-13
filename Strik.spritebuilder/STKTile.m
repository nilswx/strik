//
//  STKTile.m
//  Strik
//
//  Created by Matthijn Dijkstra on 13/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKTile.h"

#import "STKMatchPlayer.h"
#import "STKBoard.h"

@interface STKTile()

@property (nonatomic, assign) char selectedBy;

@end

@implementation STKTile

#pragma mark init
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

#pragma mark position
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

#pragma mark selection
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
