//
//  STKTimelineItemNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 24/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"
#import "STKAvatar.h"

@interface STKTimelineItemNode : CCNode

@property STKAvatar *avatar;
@property CCLabelTTF *content;
@property CCLabelTTF *time;

+ (id)timelineItemNodeWithAvatar:(STKAvatar *)avatar content:(NSString *)content andTime:(int)timestamp;

@end
