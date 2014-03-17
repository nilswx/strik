//
//  STKBoardNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@class STKBoard;

@interface STKBoardNode : CCNodeColor

// The board for this node (who would have thought that by reading the name)
@property (nonatomic, weak) STKBoard *board;

// When set to YES we can select, else selections are ignored
@property BOOL userSelectionEnabled;

@end
