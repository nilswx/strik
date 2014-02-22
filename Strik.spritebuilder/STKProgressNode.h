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


@end
