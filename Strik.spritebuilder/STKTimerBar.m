//
//  STKNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKTimerBar.h"

@implementation STKTimerBar

- (void)setWidth:(CGFloat)width
{
	self.contentSize = CGSizeMake(width, self.contentSize.height);
}

- (void)setHeight:(CGFloat)height
{
	self.contentSize = CGSizeMake(self.contentSize.width, height);
}

- (CGFloat)width
{
	return self.contentSize.width;
}

- (CGFloat)height
{
	return self.contentSize.height;
}

@end
