//
//  STKAchievementsScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAchievementsScene.h"

#import "STKLetterBlock.h"

@interface STKAchievementsScene()
{
	CCPhysicsNode* physics;
}
@end

@implementation STKAchievementsScene

- (void)sceneWillBegin
{
	[self dispenseNextBlock:0];
}

- (void)dispenseNextBlock:(NSNumber*)obj
{
	// Cast number
	int idx = [obj intValue];
	
	// Pick next letter from word
	static const NSString* word = @"STRIK";
	char letter = [word characterAtIndex:(idx % word.length)];
	
	// Pick next color
	ccColor3B green = {4, 189, 175};
	ccColor3B red = {241, 75, 106};
	CCColor* color = [CCColor colorWithCcColor3b:(idx % 2) ? green : red];
	
	// Spawn block
	STKLetterBlock* block = [STKLetterBlock blockWithLetter:letter color:color];
	block.position = ccp(50 + arc4random_uniform(290), 600);
	[self->physics addChild:block];
	
	// Next after one second
	[self performSelector:@selector(dispenseNextBlock:) withObject:@(idx + 1) afterDelay:1];
}

@end
