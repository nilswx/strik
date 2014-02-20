//
// Created by Matthijn Dijkstra on 04/12/13.
// Copyright (c) 2013 Indev. All rights reserved.
//


#import "STKProgression.h"


@implementation STKProgression

static NSArray *levels;

+ (void)setLevels:(NSArray *)newLevels
{
    levels = newLevels;

//    for(int i = 1; i < [STKProgression levelCount] + 1; i++)
//    {
//        STKLevel level = [STKProgression levelForLevelNumber:i];
//    }
}

+ (int)levelCount
{
    return (int)levels.count;
}

+ (STKLevel)levelForLevelNumber:(int)levelNumber
{
    NSValue *wrapper = [levels objectAtIndex:levelNumber - 1];
    STKLevel level;
    [wrapper getValue:&level];
    return level;
}

+ (int)levelForXP:(int)xp
{
    for(int i = 1; i < [STKProgression levelCount] + 1; i++)
    {
        STKLevel level = [STKProgression levelForLevelNumber:i];
        if(xp >= level.begin && xp <= level.end)
        {
            return i;
        }
    }

    return [STKProgression levelCount];
}

- (int)level
{
    return [STKProgression levelForXP:self.xp];
}

@end