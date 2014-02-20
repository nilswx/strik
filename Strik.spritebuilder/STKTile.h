//
//  STKTile.h
//  Strik
//
//  Created by Matthijn on Oct 23, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

typedef struct {
    int column;
    int row;
} STKTilePosition;

@class STKBoard;
@class STKMatchPlayer;

@interface STKTile : STKModel

@property (nonatomic, readonly) SInt8 tileId;
@property (nonatomic, weak, readonly) STKBoard *board;

@property (nonatomic, readonly) STKTilePosition position;
@property (nonatomic, readonly) int column;
@property (nonatomic, readonly) int row;

@property (nonatomic, assign) char letter;

@property(nonatomic) BOOL isRemoved;

- (id)initWithBoard:(STKBoard *)board column:(int)column andTileId:(SInt8)tileId;
+ (id)tileForBoard:(STKBoard *)board column:(int)column andTileId:(SInt8)tileId;

- (void)selectFor:(STKMatchPlayer*)player;

- (void)deselectFor:(STKMatchPlayer*)player;

- (BOOL)isSelectedBy:(STKMatchPlayer*)player;

@end
