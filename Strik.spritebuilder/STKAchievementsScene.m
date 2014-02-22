//
//  STKAchievementsScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAchievementsScene.h"

#import "STKLetterBlockDispenser.h"

@interface STKAchievementsScene()

@property CCPhysicsNode* physics;
@property STKLetterBlockDispenser* dispenser;

@property int spawnX;

@end

@implementation STKAchievementsScene

- (void)sceneWillBegin
{
	// Create array with colors
	NSArray* colors = @[[CCColor colorWithCcColor3b:ccc3(4, 189, 175)],
						[CCColor colorWithCcColor3b:ccc3(241, 75, 106)]];
	
	// Create dispenser
	self.dispenser = [STKLetterBlockDispenser dispenserWithLetters:@"STRIK" colors:colors physics:self.physics];
	
	// Automate dispenser
	[self schedule:@selector(nextBlock) interval:1.0];
}

- (void)nextBlock
{
	// Operate dispenser
	[self.dispenser dispenseNextBlockAt:ccp(self.spawnX, 600)];
	
	// Next!
	self.spawnX += 60;
	if(self.spawnX >= 320)
	{
		self.spawnX = 0;
	}
}

@end
