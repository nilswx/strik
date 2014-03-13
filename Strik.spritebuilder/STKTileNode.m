//
//  STKTileNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKTileNode.h"

#import "STKTile.h"
#import "STKBoard.h"

#import "NSObject+Observer.h"

@interface STKTileNode()

// The tile for this node
@property STKTile *tile;

// The letter label
@property CCLabelTTF *letterLabel;

@end

@implementation STKTileNode

+ (id)newTileNodeWithTile:(STKTile *)tile
{
	STKTileNode *tileNode = (STKTileNode *)[CCBReader load:@"Game Scene/Tile.ccbi"];
	
	// Set the tile and listen for changes
	tileNode.tile = tile;
	[tileNode observeModel:tile];
	
	return tileNode;
}

#pragma mark Model state changes
- (void)tile:(STKTile *)tile valueChangedForLetter:(NSNumber *)letter
{
	self.letterLabel.string = [NSString stringWithFormat:@"%c", tile.letter];
}

- (void)tile:(STKTile *)tile valueChangedForIsRemoved:(NSNumber *)isRemoved
{
    if([isRemoved boolValue])
    {
        [self animateToRemovedState];
    }
}

- (void)tile:(STKTile *)tile valueChangedForSelectedBy:(STKMatchPlayer *)player
{
    // Determine who have selected it
    BOOL byPlayer = [tile isSelectedBy:tile.board.player];
    BOOL byOpponent = [tile isSelectedBy:tile.board.opponent];
	
    // Process it
    [self animateToSelectedByPlayer:byPlayer andOpponent:byOpponent];
}

#pragma mark animation
- (void)animateToNormalState
{
	NSLog(@"animating to normal state");
}

- (void)animateToRemovedState
{
	[self removeFromParent];
}

- (void)animateToSelectedByPlayer:(BOOL)byPlayer andOpponent:(BOOL)byOpponent
{
	// Selected by none, we can animate to normal state
	if(!byPlayer && !byOpponent)
	{
		[self animateToNormalState];
	}
	else
	{
		NSLog(@"Amimating to selection by player %d and opponent %d", byPlayer, byOpponent);
	}
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}

@end
