//
//  STKLevelNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLevelNode.h"

// The relative increasse of scaling size
#define LEVEL_SCALE_SIZE 0.3f

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_BACKGROUND,
	Z_LABEL
};

@interface STKLevelNode()

// The background circle
@property CCDrawNode *backgroundCircle;

// The label which holds the contens
@property CCLabelTTF *label;

// The scale action for animation
@property (nonatomic) CCAction *scaleAction;

@end

@implementation STKLevelNode

- (void)setBackgroundColor:(CCColor *)backgroundColor
{
	_backgroundColor = backgroundColor;
	
	if(self.backgroundCircle)
	{
		[self.backgroundCircle removeFromParent];
	}
	
	if(backgroundColor)
	{
		// Create a new circle
		self.backgroundCircle = [CCDrawNode new];
		self.backgroundCircle.zOrder = Z_BACKGROUND;
		
		// Draw it
		[self.backgroundCircle drawDot:CGPointMake(0, 0) radius:self.radius color:backgroundColor];
		
		// Center it
		self.backgroundCircle.position = CGPointMake(self.contentSize.width * self.anchorPoint.x,
									  self.contentSize.height * self.anchorPoint.y + 2);
		
		// And add to the tree
		[self addChild:self.backgroundCircle];
	}
}

- (void)setText:(NSString *)text animated:(BOOL)animated
{
	// First set text
	self.text = text;
	
	// And animate a bit
	if(animated)
	{
		[self runAction:self.scaleAction];
	}
}

- (void)setText:(NSString *)text
{
	_text = text;
	
	if(!self.label)
	{
		self.label = [CCLabelTTF labelWithString:text fontName:@"Global/Fonts/UbuntuTitling-Bold.ttf" fontSize:self.radius * 1.4];

		// Make sure it is centered
		self.label.position = CGPointMake(self.contentSize.width * self.anchorPoint.x,
									  self.contentSize.height * self.anchorPoint.y);

		self.label.fontColor = self.fontColor;
		self.label.zOrder = Z_LABEL;

		[self addChild:self.label];
	}
	
	self.label.string = text;
}

- (void)setFontColor:(CCColor *)fontColor
{
	_fontColor = fontColor;
	self.label.fontColor = fontColor;
}

- (CGFloat)radius
{
	// Substract 2px from the size so it wil be not cut of with aliassing
	return (self.contentSize.width / 2) - 2;
}

- (CCAction *)scaleAction
{
	if(!_scaleAction)
	{
		CGFloat currentScale = self.backgroundCircle.scale;
		
		// First scale up
		CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.25 scale:currentScale + LEVEL_SCALE_SIZE];
		CCActionEaseElasticOut *scaleUpEased = [CCActionEaseElasticOut actionWithAction:scaleUp period:1.0f];
		
		// Then scale down
		CCActionScaleTo *scaleDown = [CCActionScaleTo actionWithDuration:0.25 scale:currentScale];
		CCActionEaseElasticOut *scaleDownEased = [CCActionEaseElasticOut actionWithAction:scaleDown period:1.0f];

		// And combine
		_scaleAction = [CCActionSequence actionWithArray:@[scaleUpEased, scaleDownEased]];
	}
	
	return _scaleAction;
}

@end
