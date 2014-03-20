//
//  STKAchievementsController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAchievementsController.h"

#import "STKHomeScene.h"
#import "STKAchievementsScene.h"
#import "GridNode.h"

@interface STKAchievementsController();

@property GridNode *achievementsGrid;

@end

@implementation STKAchievementsController

#pragma mark buttons
- (void)onBackButton:(CCButton *)button
{
	[self transitionTo:[STKHomeScene class] direction:CCTransitionDirectionRight];
}

- (void)onScrollTopButton:(CCButton *)button
{
	// Scrolling back to top when tapping top bar
	[self.achievementsGrid.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


@end
