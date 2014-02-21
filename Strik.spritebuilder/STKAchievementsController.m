//
//  STKAchievementsController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAchievementsController.h"

#import "STKDirector.h"
#import "STKHomeScene.h"

@implementation STKAchievementsController

- (void)onBackButton:(CCButton *)button
{
	[self transitionTo:[STKHomeScene class] direction:CCTransitionDirectionRight];
}

@end
