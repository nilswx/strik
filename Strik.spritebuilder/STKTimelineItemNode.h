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

// Based on the property the line will be changes so the top and bottom have the correct lines
@property (nonatomic, assign) TimelinePositionType timelinePosition;

// Returns a new timeline item node from disk
+ (id)newTimelineItemNodeWithActor:(STKPlayer *)actor action:(NSString *)action subject:(NSString *)subject andTimestamp:(int)timestamp;

@end
