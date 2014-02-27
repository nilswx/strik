//
//  STKTimelineItemNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 24/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"
#import "STKPLayer.h"

typedef NS_ENUM(NSInteger, TimelinePositionType)
{
	TimelinePositionTypeTop,
	TimelinePositionTypeCenter,
	TimelinePositionTypeBottom,
	TimelinePositionTypeOnly
};

@interface STKTimelineItemNode : CCNode

// The player for this timeline event
@property (nonatomic) STKPlayer *actor;

// The content for the label
@property (nonatomic) NSString *content;

// And the time
@property (nonatomic, assign) int *timestamp;

// Based on the property the line will be changes so the top and bottom have the correct lines
@property (nonatomic, assign) TimelinePositionType timelinePosition;

@end
