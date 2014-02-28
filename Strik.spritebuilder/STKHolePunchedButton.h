//
//  STKHolePunchedButton.h
//  Strik
//
//  Created by Matthijn Dijkstra on 28/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCButton.h"

@class CCNode;

@interface STKHolePunchedButton : CCButton

- (id)initWithCenterNode:(CCNode *)centerNode;
+ (id)holePunchedButtonWithCenterNode:(CCNode *)centerNode;

@end
