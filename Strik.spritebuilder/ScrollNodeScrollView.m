//
//  ScrollNodeScrollView.m
//  Strik
//
//  Created by Matthijn Dijkstra on 03/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "ScrollNodeScrollView.h"

@implementation ScrollNodeScrollView

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview touchesCancelled:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)anEvent
{
	[self.superview touchesEnded:aTouches withEvent:anEvent];
}

@end
