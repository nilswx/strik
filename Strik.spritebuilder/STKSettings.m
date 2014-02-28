//
//  STKSettings.m
//  Strik
//
//  Created by Matthijn Dijkstra on 28/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSettings.h"

@implementation STKSettings

+ (void)loadSettings
{
	// If no settings are set (e.g first boot) set some defaults for those settings
	if([STKSettings objectForkey:SETTINGS_KEY_SOUND] == nil)
	{
		[STKSettings setBool:YES forKey:SETTINGS_KEY_SOUND];
	}
	
	if([STKSettings objectForkey:SETTINGS_KEY_LANGUAGE] == nil)
	{
		// Get the system language
		NSString *systemLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
		
		// An array of the allowed languages
		NSArray *allowedLanguages = @[@"us", @"nl", @"es"];
		
		// The default language is us, so setting to that
		__block NSString *currentLanguage = @"us";
		
		// Itterate through allowed languages, when it is there, set it as current language
		[allowedLanguages enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
			if([obj isEqualToString:systemLanguage])
			{
				currentLanguage = obj;
			}
		}];
		
		// And save current language in settings
		[self setObject:currentLanguage forKey:SETTINGS_KEY_LANGUAGE];
	}
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
	[[STKSettings defaults] setObject:object forKey:key];
}

+ (id)objectForkey:(NSString *)key
{
	return [[STKSettings defaults] objectForKey:key];
}

+ (void)setBool:(BOOL)boolean forKey:(NSString *)key
{
	[[STKSettings defaults] setBool:boolean forKey:key];
}

+ (BOOL)boolforKey:(NSString *)key
{
	return [[STKSettings defaults] boolForKey:key];
}

+ (NSUserDefaults *)defaults
{
	return [NSUserDefaults standardUserDefaults];
}

@end
