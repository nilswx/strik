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

// Falling speed per second in UI points
#define FALLING_SPEED 1000

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_INDEX_TILE_CONTAINER,
	Z_INDEX_BOARD_LINE
};

@interface STKBoardNode()

// The background node
@property CCNodeColor *background;

// The first drop for all tiles shows all tiles where they should be instead of dropping them all down
@property BOOL isFirstDrop;

// The tile container (every tile must be placed in here)
@property CCNode *tileContainer;

// The last tile node is used for "directions" from a tile to another tile with detection for improved direction detection
@property (nonatomic) STKTileNode *lastTileNode;

@end

@implementation STKBoardNode

#pragma mark init
- (void)onEnter
{
	[super onEnter];

	// Set touch enabled
	self.userInteractionEnabled = YES;
	
	// The initial drop places tiles at the bottom, so you won't see them fall
	self.isFirstDrop = YES;
	
	// Add the board lines
	[self addBoardLines];
	
	// Setup the tile container
	[self setupTileContainer];
}

- (void)addBoardLines
{
	// Vertical lines
	for(CGFloat x = TILE_SIZE; x < self.contentSizeInPoints.width; x += TILE_SIZE)
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
	for(CGFloat y = TILE_SIZE; y < self.contentSizeInPoints.height; y += TILE_SIZE)
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

- (void)setupTileContainer
{
	// Create the tilecontainer
	self.tileContainer = [CCNode node];
	self.tileContainer.contentSizeType = CCSizeTypeNormalized;
	self.tileContainer.contentSize = CGSizeMake(1, 1);
	
	self.tileContainer.anchorPoint = CGPointMake(0, 0);
	
	self.tileContainer.zOrder = Z_INDEX_TILE_CONTAINER;
	
	[self addChild:self.tileContainer];
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
	[self insertNodeFromTiles:freshTiles];
}

- (void)insertNodeFromTiles:(NSArray *)tiles
{
	if(tiles)
	{
		// The starting Y position (they fall from this height)
		CGFloat startY;
		
		// The initial tiles are drawn where they should be
		if(self.isFirstDrop && tiles)
		{
			startY = TILE_SIZE;
			
			// There is only one first drop
			self.isFirstDrop = NO;
		}
		// And the new ones are drawn at top
		else
		{
			startY = self.scene.contentSizeInPoints.height;
		}
		
		// Todo: Fix this somehow that it knows other tiles are in place up there...
		// The Y position might be different for different collumns while adding (e.g an L shape)
		NSMutableArray *yPositions = [NSMutableArray arrayWithCapacity:self.board.size.width];
		for(int col = 0; col < self.board.size.width; col++)
		{
			[yPositions addObject:[NSNumber numberWithFloat:startY]];
		}
		
		// Loop through every tile and position them
		for(STKTile *tile in tiles)
		{
			// Create a new tile node for this tile
			STKTileNode *tileNode = [STKTileNode newTileNodeWithTile:tile andBoardNode:self];
			
			// Get the tile size
			CGSize tileSize = [tileNode contentSizeInPoints];
			
			// Get the Y position for the tile in this collumn
			CGFloat yPosition = [[yPositions objectAtIndex:tile.column] floatValue];
			
			// Get the X position for this tile
			CGFloat xPosition = tileSize.width * tile.column;
			
			// Position the tile
			tileNode.position = CGPointMake(xPosition, yPosition);
			
			// And add it to the physics world
			[self.tileContainer addChild:tileNode];
			
			// Increase Y Position for this collumn (so we can stack)
			yPosition += tileSize.height;
			[yPositions setObject:[NSNumber numberWithFloat:yPosition] atIndexedSubscript:tile.column];
		}
	}
}

#pragma mark Moving of tiles
- (void)update:(CCTime)delta
{
	[self moveTiles:delta];
}

- (void)moveTiles:(CCTime)delta
{
	// Note: The tiles are added bottom left (the tiles anchor point is top left) so 0.0 would just move the tile bottom left ouff screen tile height.tile height would move it at bottom left in screen
	
	// The maximum distance to move (when possible)
	CGFloat maxDistanceToMove = delta * FALLING_SPEED;
	
	// Itterate over every tile and move it the required distance
	for(STKTileNode *tileNode in self.tileContainer.children)
	{
		STKTile *tile = tileNode.tile;
		
		CGFloat currentY = tileNode.position.y;
		
		// This is the minimum Y a tile can have for its position (e.g on the bottom of the screen or just above another node)
		CGFloat minY = (tile.row + 1) * TILE_SIZE;
		
		// We can still move a certain distance
		if(currentY > minY)
		{
			// Determine the space available to move
			CGFloat currentSpaceToMove = currentY - minY;
			
			// Calculating the distance to move based on maximum space to move at this speed and the available space
			CGFloat distanceToMove = MIN(maxDistanceToMove, currentSpaceToMove);
			
			// And move given distance
			tileNode.position = CGPointMake(tileNode.position.x, currentY - distanceToMove);
		}
	}
}

#pragma mark User interaction
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self touchUpdatedAtLocation:[touch locationInNode:self.tileContainer]];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self touchUpdatedAtLocation:[touch locationInNode:self.tileContainer]];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self touchEndedAtLocation:[touch locationInNode:self.tileContainer]];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self touchEndedAtLocation:[touch locationInNode:self.tileContainer]];
}

- (void)touchUpdatedAtLocation:(CGPoint)location
{
	// Only continue when we are touching inside the tile container box
	if(CGRectContainsPoint(self.tileContainer.boundingBox, location))
	{
		// Get the tile for current location
		STKTile *tile = [self tileAtLocation:location];
		
		// You can't select a tile the same time as an opponent (since the opponent now allready played the word when you receive the selection)
		if(![tile isSelectedBy:self.board.opponent])
		{
			STKTileNode *node = tile.node;
			
			// Don't update the selection mulitple times for the same tile node
			if(self.lastTileNode != node)
			{
				// Determine if we should select the next node based on the angle of entrance (better for diagonal detection)
				BOOL shouldSelectTileNode = ((self.lastTileNode == nil) || [self tileNode:node testAngleInPoint:location]);
				if(shouldSelectTileNode)
				{
					// Select the tile
					[self.board selectTile:tile];
					
					// Set new node as last node
					self.lastTileNode = node;
				}
			}
		}
	}
	// When going outside of the bounding box we end the touches
	else
	{
		[self touchEndedAtLocation:location];
	}
}

- (void)touchEndedAtLocation:(CGPoint)location
{
	self.lastTileNode = nil;
	[self.board clearSelectionFor:self.board.player];
}

- (BOOL)tileNode:(STKTileNode *)tileNode testAngleInPoint:(CGPoint)point
{
	CGRect centerOfLastTileNode = [self.lastTileNode boundingBox];
	
	// The angles are in radian, radian does not start at "the north" but "east"
	float angle = atan2f(point.y - centerOfLastTileNode.origin.y - centerOfLastTileNode.size.height / 2, point.x - centerOfLastTileNode.origin.x - centerOfLastTileNode.size.width / 2);
	
	// Determine the position on the board of the tile which wants to be selected viewing from the last selected tile
	STKBoardDirection direction = [self.board directionFromTile:self.lastTileNode.tile toTile:tileNode.tile];
	
	// Based on the angle and the relative position we can now say if we want the selection or not.
	return [self angleDirection:angle isCorrectForDirection:direction];
}

- (BOOL)angleDirection:(float)angle isCorrectForDirection:(STKBoardDirection)direction
{
	// Each direction (north, nortwest, ...) is two times one eighth PI (smaller and larger than)
	float eighthPI = M_PI / 8;
	
	// A static array containing the angles in radian for each direction (got it with help from: http://paulboxley.com/blog/2012/05/angles) somehow it is inverted here?
	static float WIND_DIRECTIONS[8] = {
		// North
		M_PI / 4 * 2,
		// North East
		M_PI / 4 * 1,
		// East
		0,
		// South East
		-M_PI / 4 * 1,
		// South
		-M_PI / 4 * 2,
		// South West
		-M_PI / 4 * 3,
		// West
		-M_PI,
		// North West
		M_PI / 4 * 3
	};
	
	// With these the algorithm can be tweaked, higher numbers mean a wider angle hit detection, the sum of the numbers should be 2
	static float DIAGONAL_MULTIPLIER = 1.4;
	static float HORIZONTAL_VERTICAL_MULTIPLIER = 0.6;
	
	// Yeah, West is the strange kid on the block
	float calculationAngle = angle;
	if(direction == STKBoardDirectionWest)
	{
		// West can be positive or negative, this is how we solve that. We make it an always negative number
		calculationAngle = ABS(angle) * -1;
	}
	
	// Get the direction fromt the array for the current wind direction and check if the angle is correct.
	float directionAngle = WIND_DIRECTIONS[direction];
	
	// Apply the direction tweaking
	float angleSize;
	if(direction == STKBoardDirectionNorth || direction == STKBoardDirectionEast || direction == STKBoardDirectionSouth || direction == STKBoardDirectionWest)
	{
		angleSize = eighthPI * HORIZONTAL_VERTICAL_MULTIPLIER;
	}
	else
	{
		angleSize = eighthPI * DIAGONAL_MULTIPLIER;
	}
	
	if(calculationAngle >= directionAngle - angleSize  && calculationAngle <= directionAngle + angleSize)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (STKTile *)tileAtLocation:(CGPoint)location
{
	// Get the node for this position
	STKTilePosition position;
	position.column = floor(location.x / TILE_SIZE);
	position.row = floor(location.y / TILE_SIZE);
	
	return [self.board tileAtPoint:position];
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}
@end
