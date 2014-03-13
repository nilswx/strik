//
//  STKBoardNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKBoardNode.h"
#import "STKTileNode.h"

#import "STKBoard.h"
#import "STKTile.h"

#import "NSObject+Observer.h"

#define BOARD_LINE_COLOR [CCColor colorWithWhite:0 alpha:0.3f]
#define LINE_PADDING 64.5f

typedef NS_ENUM(NSInteger, zIndex)
{
	
	Z_INDEX_BOARD_LINE
};

@interface STKBoardNode()

// The background node
@property CCPhysicsNode *background;

@end

@implementation STKBoardNode

#pragma mark init
- (void)onEnter
{
	[super onEnter];
	
	[self addBoardLines];
}

- (void)addBoardLines
{
	// Vertical lines
	for(CGFloat x = LINE_PADDING; x < self.contentSizeInPoints.width; x += LINE_PADDING)
	{
		CCNodeColor *verticalLine = [CCNodeColor nodeWithColor:BOARD_LINE_COLOR];

		// Size is full height and 1px width
		verticalLine.contentSizeType = CCSizeTypeMake(CCSizeUnitPoints, CCSizeUnitNormalized);
		verticalLine.contentSize = CGSizeMake(0.5, 1);
		
		verticalLine.position = CGPointMake(x, 0);
		verticalLine.zOrder = Z_INDEX_BOARD_LINE;
		
		[self addChild:verticalLine];
	}
	
	// Horizontal lines
	for(CGFloat y = LINE_PADDING; y < self.contentSizeInPoints.height; y += LINE_PADDING)
	{
		CCNodeColor *horizontalLine = [CCNodeColor nodeWithColor:BOARD_LINE_COLOR];
		
		// Size is full width and 1px height
		horizontalLine.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
		horizontalLine.contentSize = CGSizeMake(1, 0.5);
		
		horizontalLine.position = CGPointMake(0, y);
		horizontalLine.zOrder = Z_INDEX_BOARD_LINE;
		
		[self addChild:horizontalLine];
	}
}

- (void)setBoard:(STKBoard *)board
{
	if(_board)
	{
		NSAssert(false, @"Can only assign board once!");
	}
	
	if(board)
	{
		_board = board;
		[self observeModel:board];
	}
}

#pragma mark model events
- (void)board:(STKBoard *)board valueChangedForFreshTiles:(NSArray *)freshTiles
{
	NSLog(@"Board tiles %@", freshTiles);
	NSLog(@"Physics %@", self.physicsWorld);
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}
@end
