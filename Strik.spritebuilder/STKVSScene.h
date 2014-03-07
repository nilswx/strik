//
//  STKVSScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKVSCard;

@interface STKVSScene : STKScene

@property (readonly) STKVSCard *playerOneCard;

@property (readonly) STKVSCard *playerTwoCard;

@end
