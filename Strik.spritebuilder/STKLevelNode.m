//
//  STKLevelNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLevelNode.h"

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_BACKGROUND,
	Z_LABEL
};


@interface STKLevelNode()

@property CCDrawNode *backgroundCircle;

@property CCLabelTTF *label;

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
		
		// Draw it at center
		self.backgroundCircle.contentSizeType = CCSizeTypeNormalized;
		[self.backgroundCircle drawDot:CGPointMake(50, 50) radius:self.radius color:backgroundColor];
		
		// And add to the tree
		[self addChild:self.backgroundCircle];
	}
}

- (void)setText:(NSString *)text
{
	_text = text;
	
	if(!self.label)
	{
		self.label = [CCLabelTTF labelWithString:text fontName:@"Global/Fonts/UbuntuTitling-Bold.ttf" fontSize:self.radius * 1.4];

		self.label.position = CGPointMake(50, 48);

		self.label.fontColor = self.fontColor;
		self.label.zOrder = Z_LABEL;

		[self addChild:self.label];
	}
	else
	{
		self.label.string = text;
	}

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

@end
