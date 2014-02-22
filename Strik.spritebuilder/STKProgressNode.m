//
//  STKProgressNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKProgressNode.h"

#define BORDER_SIZE 4

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_BORDER,
	Z_LIGHT_SHADE,
	Z_DARK_SHADE
};

@interface STKProgressNode()

// The border (everything contains of a left and right circle, with a bar in between
@property CCDrawNode *leftBorderCircle;
@property CCDrawNode *rightBorderCircle;
@property CCNodeColor *centerBar;

// The darker shade
@property CCDrawNode *darkLeftCircle;
@property CCDrawNode *darkRightCircle;
@property CCNodeColor *darkCenterBar;

// The lighter shade
@property CCDrawNode *lightLeftCircle;
@property CCDrawNode *lightRightCircle;
@property CCNodeColor *lightCenterBar;

@end

@implementation STKProgressNode

- (void)setBorderColor:(CCColor *)borderColor
{
	_borderColor = borderColor;

	[self.leftBorderCircle removeFromParent];
	[self.rightBorderCircle removeFromParent];
	[self.centerBar removeFromParent];
	
	if(borderColor)
	{
		// Draw a circle on both ends
		
		// Left circle
		self.leftBorderCircle = [CCDrawNode new];
		[self.leftBorderCircle drawDot:CGPointMake(self.radius, 0) radius:self.radius color:self.borderColor];
		
		self.leftBorderCircle.zOrder = Z_BORDER;
		[self addChild:self.leftBorderCircle];
		
		// Right circle
		self.rightBorderCircle = [CCDrawNode new];
		[self.rightBorderCircle drawDot:CGPointMake(self.contentSizeInPoints.width - self.radius, 0) radius:self.radius color:self.borderColor];

		self.rightBorderCircle.zOrder = Z_BORDER;
		[self addChild:self.rightBorderCircle];
		
		// Draw a line in between, et voila, it looks like the progress bar
		self.centerBar = [CCNodeColor nodeWithColor:self.borderColor width:self.contentSizeInPoints.width - (self.radius * 2) height:self.radius * 2 - 1];
		self.centerBar.position = CGPointMake(self.radius, -self.radius + 0.5);
		
		self.centerBar.zOrder = Z_BORDER;
		[self addChild:self.centerBar];
	}
}

- (void)setLightShade:(CCColor *)lightShade
{
	_lightShade = lightShade;
	
	[self.lightLeftCircle removeFromParent];
	[self.lightRightCircle removeFromParent];
	[self.lightCenterBar removeFromParent];
	
	if(lightShade)
	{
		// Left circle
		self.lightLeftCircle = [CCDrawNode new];
		[self.lightLeftCircle drawDot:CGPointMake(self.radius, 0) radius:self.radius - BORDER_SIZE color:self.lightShade];
		
		self.lightLeftCircle.zOrder = Z_LIGHT_SHADE;
		[self addChild:self.lightLeftCircle];
		
		// Right circle
		self.lightRightCircle = [CCDrawNode new];
		[self.lightRightCircle drawDot:CGPointMake(self.contentSizeInPoints.width - self.radius, 0) radius:self.radius - BORDER_SIZE color:self.lightShade];
		
		self.lightRightCircle.zOrder = Z_LIGHT_SHADE;
		[self addChild:self.lightRightCircle];

		// Draw a line in between, et voila, it looks like the progress bar
		self.lightCenterBar = [CCNodeColor nodeWithColor:[CCColor redColor] width:self.contentSizeInPoints.width - (self.radius * 2) - (BORDER_SIZE) height:self.radius * 2 - 1 - (BORDER_SIZE * 2)];
		self.lightCenterBar.position = CGPointMake(self.radius, -self.radius + 0.5 + BORDER_SIZE);

		self.lightCenterBar.zOrder = Z_BORDER;
		[self addChild:self.lightCenterBar];
	}
}

- (CGFloat)radius
{
	return self.contentSizeInPoints.height / 2 - 2;
}

@end
