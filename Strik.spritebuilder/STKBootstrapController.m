//
//  STKBootstrapController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 20/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKBootstrapController.h"

#import "STKMusicController.h"
#import "STKClientController.h"

@implementation STKBootstrapController

- (void)enterTransitionDidFinish
{
	// Adding a slight delay, so the next animation runs a bit smoother
	[self performSelector:@selector(bootstrap) withObject:nil afterDelay:0.5];
}

- (void)bootstrap
{
	// Start music
	[self.core[@"music"] playMusicWithName:@"menu"];
	
	// Register or login!
	[self.core[@"client"] registerOrLogin];
}

@end
