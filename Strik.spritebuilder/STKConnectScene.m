//
//  STKConnectScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 20/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKConnectScene.h"

#define DOTS_DELAY 0.5f

@interface STKConnectScene()

@property CCLabelTTF *connectingDots;

@property BOOL connecting;

@end

@implementation STKConnectScene

- (void)sceneWillBegin
{
	self.connecting = YES;
	
	[self animateDots];
}

- (void)sceneWillEnd
{
	self.connecting = NO;
}

// Just changes between 1, 2 or 3 dots while connecting.
- (void)animateDots
{
	NSString *dots = self.connectingDots.string;
	
	if([dots isEqualToString:@"."])
	{
		dots = @"..";
	}
	else if([dots isEqualToString:@".."])
	{
		dots = @"...";
	}
	else if([dots isEqualToString:@"..."])
	{
		dots = @"";
	}
	else
	{
		dots = @".";
	}
	
	self.connectingDots.string = dots;
	
	if(self.connecting)
	{
		[self performSelector:@selector(animateDots) withObject:nil afterDelay:DOTS_DELAY];
	}
}

@end
