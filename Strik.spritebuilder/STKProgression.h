//
// Created by Matthijn Dijkstra on 04/12/13.
// Copyright (c) 2013 Indev. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "STKModel.h"

typedef struct {
    int begin;
    int end;
} STKLevel;

@interface STKProgression : STKModel

@property int xp;
@property (readonly) int level;

+ (void)setLevels:(NSArray *)newLevels;

+ (int)levelCount;
+ (STKLevel)levelForLevelNumber:(int)levelNumber;
+ (int)levelForXP:(int)xp;

@end