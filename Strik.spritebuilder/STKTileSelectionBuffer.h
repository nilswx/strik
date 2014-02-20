//
//  STKTileSelectionBuffer.h
//  Strik
//
//  Created by Nils on Sep 30, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKController.h"

@class STKTile;

@interface STKTileSelectionBuffer : STKController

@property(readonly) BOOL isOpen;

- (void)addTile:(STKTile*)tile;
//- (void)deselectTile:(STKTile *)tile;

- (void)endBuffer;

@end
