//
//  STKLobbyController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLobbyController.h"
#import "STKHomeScene.h"

@implementation STKLobbyController

- (void)onBackButton:(CCButton *)button
{
	[self transitionTo:[STKHomeScene class] direction:CCTransitionDirectionRight];
}

@end
