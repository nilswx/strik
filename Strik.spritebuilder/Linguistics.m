//
//  Fluent.m
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "Linguistics.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@implementation Linguistics

+ (NSString *)fluentStringWithActor:(NSString *)actor action:(NSString *)action subject:(NSString *)subject atTime:(NSDate *)time
{
	// Todo: change behaviour based on localization
	return [NSString stringWithFormat:@"%@ %@ %@ %@.", actor, action, subject, [time dateTimeUntilNow]];
}

+ (NSString *)localizedNameFromCountryCode:(NSString *)countryCode
{
	// Countrycooooode take me hooooome...
	// Todo: Get actual code
	return countryCode;
}

@end
