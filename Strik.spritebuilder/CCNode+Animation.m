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
	
	NSLog(@"%@: running animation '%@'", self, name);
	
	[self.userObject runAnimationsForSequenceNamed:name];
}

- (void)setWidth:(CGFloat)width
{
	[self setNewSize:CGSizeMake(width, self.height)];
}

- (CGFloat)width
{
	return [self currentSize].width;
}

- (void)setHeight:(CGFloat)height
{
	[self setNewSize:CGSizeMake(height, self.width)];
}

- (CGFloat)height
{
	return [self currentSize].height;
}

- (void)setNewSize:(CGSize)newSize
{
	if([self isKindOfClass:[CCControl class]])
	{
		CCControl *control = (CCControl *)self;
		control.preferredSize = newSize;
	}
	else
	{
		self.contentSize = newSize;
	}
}

- (CGSize)currentSize
{
	if([self isKindOfClass:[CCControl class]])
	{
		CCControl *control = (CCControl *)self;
		return control.preferredSize;
	}
	else
	{
		return self.contentSize;
	}
}

@end
