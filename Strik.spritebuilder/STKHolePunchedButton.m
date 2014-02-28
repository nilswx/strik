//
//  STKHolePunchedButton.m
//  Strik
//
//  Created by Matthijn Dijkstra on 28/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKHolePunchedButton.h"

@interface STKHolePunchedButton()

@property CCNode *centerNode;

@end

@implementation STKHolePunchedButton

- (id)initWithCenterNode:(CCNode *)centerNode
{
	if(self = [super initWithTitle:@"" spriteFrame:nil highlightedSpriteFrame:nil disabledSpriteFrame:nil])
	{
		self.centerNode = centerNode;

		// Fill the screen
		self.contentSizeType = CCSizeTypeNormalized;
		self.contentSize = CGSizeMake(1, 1);
		self.anchorPoint = CGPointMake(0, 0);

		self.preferredSizeType = CCSizeTypeNormalized;
		self.preferredSize = CGSizeMake(1, 1);
	}
	
	return self;
}

+ (id)holePunchedButtonWithCenterNode:(CCNode *)centerNode
{
	return [[STKHolePunchedButton alloc] initWithCenterNode:centerNode];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	// When the touch ends outside the center node, it is a touch to dismiss it
	if(!CGRectContainsPoint(self.centerNode.boundingBox, [touch locationInNode:self]))
	{
		if(self.block)
		{
			self.block(self);
		}
	}
}


@end
