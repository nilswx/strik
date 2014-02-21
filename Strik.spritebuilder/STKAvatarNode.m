//
//  STKAvatarNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAvatarNode.h"

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_BORDER,
	Z_BACKGROUND,
	Z_IMAGE
};

#define BORDER_WIDTH 5

@interface STKAvatarNode()

// The circle which makes up the outer border
@property (nonatomic)  CCDrawNode *outerCircle;

// The background
@property (nonatomic) CCDrawNode *backgroundCircle;

// The radius of the border circle
@property (readonly) CGFloat radius;

// The clipping node which will clip the image
@property CCClippingNode *clippingNode;

@end

@implementation STKAvatarNode

- (void)setBorderColor:(CCColor *)borderColor
{
	_borderColor = borderColor;
	
	// Remove the old circle if there is one
	if(self.outerCircle)
	{
		[self.outerCircle removeFromParent];
	}
	
	// When nil is passed no border color is drawn
	if(borderColor)
	{
		self.outerCircle = [self createCircleWithRadius:self.radius andColor:self.borderColor];
		self.outerCircle.zOrder = Z_BORDER;
	}
	
}

- (void)setBackgroundColor:(CCColor *)backgroundColor
{
	_backgroundColor = backgroundColor;
	
	// Remove the old circle if there is one
	if(self.backgroundCircle)
	{
		[self.backgroundCircle removeFromParent];
	}
	
	// When nil is passed no border color is drawn
	if(backgroundColor)
	{
		self.backgroundCircle = [self createCircleWithRadius:self.radius - BORDER_WIDTH andColor:self.backgroundColor];
		self.backgroundCircle.zOrder = Z_BACKGROUND;
	}
}

- (CCDrawNode *)createCircleWithRadius:(CGFloat)radius andColor:(CCColor *)color
{
	// Create a new circle
	CCDrawNode *circle = [CCDrawNode new];
	
	// Draw it at center
	circle.contentSizeType = CCSizeTypeNormalized;
	[circle drawDot:CGPointMake(50, 50) radius:radius color:color];
	
	// And add to the tree
	[self addChild:circle];
	
	return circle;
}

- (void)setMaskedImage:(CCSprite *)maskedImage
{
	// Delete old if there is one
	if(self.maskedImage)
	{
		[self.clippingNode removeFromParent];
	}
	
	_maskedImage = maskedImage;
	
	// Only set new if there is one
	if(maskedImage)
	{
		// Create the clipping node
		self.clippingNode = [CCClippingNode clippingNodeWithStencil:[CCSprite spriteWithImageNamed:@"Home Scene/top-circle-mask.png"]];
		
		// Add the image
		[self.clippingNode addChild:self.maskedImage];
		self.clippingNode.zOrder = Z_IMAGE;
		
		// Don't know what idiot thought defaulting this to one was a good idea
		self.clippingNode.alphaThreshold = 0;
		
		// Center it
		self.clippingNode.contentSizeType = CCSizeTypeNormalized;
		self.clippingNode.position = CGPointMake(50, 50);
		
		self.clippingNode.scale = 0.95f;
		
		// And add the clipping node to the tree
		[self addChild:self.clippingNode];
	}
}

- (CGFloat)radius
{
	// Substract 2px from the size so it wil be not cut of with aliassing
	return (self.contentSize.width / 2) - 2;
}

@end
