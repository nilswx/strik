//
//  Fluent.m
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "Fluent.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@implementation Fluent

+ (NSString *)fluentStringWithActor:(NSString *)actor action:(NSString *)action subject:(NSString *)subject atTime:(NSDate *)time
{
	// Todo: change behaviour based on localization
	return [NSString stringWithFormat:@"%@ %@ %@ %@.", actor, action, subject, [time dateTimeUntilNow]];
}

@end
