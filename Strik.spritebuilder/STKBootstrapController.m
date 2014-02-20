//
//  STKBootstrapController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 20/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKBootstrapController.h"

#import "STKClientController.h"

@implementation STKBootstrapController

- (void)enterTransitionDidFinish
{
	// All done, now login or create a new account
	STKClientController *clientController = self.core[@"client"];
	[clientController registerOrLogin];
}

@end
