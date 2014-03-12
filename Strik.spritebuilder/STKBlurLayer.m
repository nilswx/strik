//
//  STKBlurLayer.m
//  Strik
//
//  Created by Nils Wiersema on Mar 12, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKBlurLayer.h"

#import "CCNode_Private.h"

@implementation STKBlurLayer

- (id)init
{
	if(self = [super initWithColor:PLAYER_ONE_COLOR])
	{
		self.shaderProgram = [CCGLProgram programWithVertexShaderFilename:@"example_Twist.vsh" fragmentShaderFilename:@"example_Blur.fsh"];
		[self.shaderProgram link];
	}
	
	return self;
}

- (void)update:(CCTime)delta
{
	[self.shaderProgram updateUniforms];
}

@end
