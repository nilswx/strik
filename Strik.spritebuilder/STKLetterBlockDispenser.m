//
//  STKLetterBlockDispenser.m
//  Strik
//
//  Created by Nils Wiersema on Feb 22, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLetterBlockDispenser.h"

#import "STKLetterBlock.h"

@interface STKLetterBlockDispenser()

@property NSString* letters;
@property NSArray* colors;

@property CCPhysicsNode* physics;

@property int counter;

@end

@implementation STKLetterBlockDispenser

- (void)dispenseNextBlockAt:(CGPoint)position
{
	// Pick next letter
	char letter = [self.letters characterAtIndex:(self.counter % self.letters.length)];
	
	// Pick next color
	CCColor* color = self.colors[self.counter % self.colors.count];
	
	// Spawn block
	STKLetterBlock* block = [STKLetterBlock blockWithLetter:letter color:color];
	block.position = position;
	[self.physics addChild:block];
	
	// Next!
	self.counter++;
}

+ (STKLetterBlockDispenser*)dispenserWithLetters:(NSString*)letters colors:(NSArray*)colors physics:(CCPhysicsNode*)physics
{
	STKLetterBlockDispenser* dispenser = [[STKLetterBlockDispenser alloc] init];
	dispenser.letters = letters;
	dispenser.colors = colors;
	dispenser.physics = physics;
	
	return dispenser;
}

@end
