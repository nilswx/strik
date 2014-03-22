//
//  STKExperience.m
//  Strik
//
//  Created by Nils Wiersema on Mar 22, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKExperience.h"

@interface STKLevel()

@property STKLevel* next;

@end

@implementation STKLevel

- (int)totalToNext
{
	return (self.next.beginXP - self.beginXP);
}

- (int)progressToNext:(int)currentXP
{
	return (currentXP - self.beginXP);
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%d [%d-%d]", self.num, self.beginXP, self.next.beginXP];
}

+ (STKLevel*)level:(int)num beginXP:(int)beginXP
{
	STKLevel* level = [STKLevel new];
	level->_num = num;
	level->_beginXP = beginXP;
	
	return level;
}

@end

@implementation STKExperience

static NSArray* levelCache;

+ (void)setLevels:(NSArray*)levels
{
	// Link the levels
	STKLevel* prev = nil;
	for(int numLevel = (int)levels.count; numLevel >= 1; numLevel--)
	{
		STKLevel* level = [levels objectAtIndex:numLevel - 1];
		level.next = prev;
		prev = level;
	}
	
	// Store the array
	levelCache = levels;
}

+ (STKLevel*)levelForXP:(int)xp
{
	for(STKLevel* level in levelCache)
	{
		if(!level.next || xp <= level.next.beginXP)
		{
			return level;
		}
	}
	
	NSLog(@"Experience: levels not loaded");
	return nil;
}

@end
