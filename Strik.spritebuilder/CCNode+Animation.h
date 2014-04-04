//
//  CCNode+Animation.h
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

typedef void (^animationBlock)();

@interface CCNode (Animation)

// Only use these with actions (they redraw too) else use contentSize
@property CGFloat width;
@property CGFloat height;

- (void)runTimelineNamed:(NSString *)name;
- (void)runTimelineNamed:(NSString *)name withCallback:(animationBlock)block;

@end
