//
//  STKTimelineItemNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 24/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"
#import "STKPLayer.h"

@interface STKTimelineItemNode : CCNode

// The player for this timeline event
@property (nonatomic) STKPlayer *actor;

// The content for the label
@property (nonatomic) NSString *content;

// And the time
@property (nonatomic, assign) int *timestamp;

@end
