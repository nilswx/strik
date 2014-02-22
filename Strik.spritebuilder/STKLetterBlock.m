//
//  STKPhysicsBlock.m
//  Strik
//
//  Created by Nils Wiersema on Feb 21, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLetterBlock.h"

@interface STKLetterBlock()
{
	CCLabelTTF* letter;
	CCNodeColor* inner;
}
@end

@implementation STKLetterBlock : CCNode

+ (STKLetterBlock*)blockWithLetter:(char)letter color:(CCColor*)color
{
	STKLetterBlock* block = (STKLetterBlock*)[CCBReader load:@"Connect/LetterBlock"];
	block->letter.string = [NSString stringWithFormat:@"%c", letter];
	block->inner.color = color;
	
	return block;
}

@end
