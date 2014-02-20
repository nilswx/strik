//
//  STKMessageHandler.m
//  Strik
//
//  Created by Nils on Sep 29, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKMessageHandler.h"

@implementation STKMessageHandler

- (id)initWithTarget:(id)target andSelector:(SEL)selector
{
	if(self = [super init])
	{
		_target = target;
		_selector = selector;
	}
	
	return self;
}

- (void)handleMessage:(STKIncomingMessage*)message
{
	[self.target performSelector:self.selector withObject:message];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@:%@", NSStringFromClass([self.target class]), NSStringFromSelector(self.selector)];
}

+ (STKMessageHandler*)handlerForSelector:(SEL)selector onTarget:(id)target
{
	return [[STKMessageHandler alloc] initWithTarget:target andSelector:selector];
}

@end
