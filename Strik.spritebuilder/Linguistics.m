//
//  Fluent.m
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "Linguistics.h"

#import "STKSettings.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@implementation Linguistics

+ (NSString *)fluentStringWithActor:(NSString *)actor action:(NSString *)action subject:(NSString *)subject atTime:(NSDate *)time
{
	// Todo: change behaviour based on localization
	return [NSString stringWithFormat:@"%@ %@ %@ %@!", actor, action, subject, [time dateTimeUntilNow]];
}

+ (NSString *)localizedNameFromCountryCode:(NSString *)countryCode
{
	// Countrycooooode take me hooooome...
	
	// Get the current language
	NSString *language = [STKSettings objectForkey:SETTINGS_KEY_LANGUAGE];
	
	// Get the locale (contains the country list based on locale :) ) phew!
	NSLocale *locale = [NSLocale localeWithLocaleIdentifier:language];

	// And return the country name for code
	return [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
}


// Shorten a string and add elipsis if needed
+ (NSString *)shorten:(NSString *)string withMaxLength:(int)maxLength
{
	// Only usefull if it is longer then maxlength + 1.. else it will be even long with an added elipsis if it was before
	if(string.length > maxLength + 1)
	{
		// Zero based, thats why -1
		return [NSString stringWithFormat:@"%@…", [string substringToIndex:maxLength - 1]];
	}
	
	return string;
}

@end
