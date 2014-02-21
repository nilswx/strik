//
//  CCNode+Animation.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode+Animation.h"

#import <CCBAnimationManager.h>

@implementation CCNode (Animation)

- (void)runTimelineNamed:(NSString *)name
{
	[self runTimelineNamed:name withCallback:nil];
}

- (void)runTimelineNamed:(NSString *)name withCallback:(animationBlock)block
{
	if(block)
	{
		[self.userObject setCompletedAnimationCallbackBlock:block];
	}
	
	[self.userObject runAnimationsForSequenceNamed:name];
}

@end
