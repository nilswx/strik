//
//  STKTileNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKTileNode.h"

@implementation STKTileNode

+ (id)newTileNode
{
	STKTileNode *tileNode = (STKTileNode *)[CCBReader load:@"Game Scene/Tile.ccbi"];
	return tileNode;
}

@end
