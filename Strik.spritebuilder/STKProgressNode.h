//
//  STKProgressNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@interface STKProgressNode : CCNode

// The color of the border
@property (nonatomic) CCColor *borderColor;

// The darker (fill color)
@property (nonatomic) CCColor *darkShade;

// The lighter (fill color)
@property (nonatomic) CCColor *lightShade;

// Values for this label (read only)
@property (readonly) int value;
@property (readonly) int totalValue;

// Give it a value, and a total value, it will take care of the rest
- (void)setValue:(int)value ofTotalValue:(int)totalValue;

@end
