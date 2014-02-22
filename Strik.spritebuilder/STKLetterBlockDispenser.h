//
//  STKLetterBlockDispenser.h
//  Strik
//
//  Created by Nils Wiersema on Feb 22, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKLetterBlockDispenser : NSObject

- (void)dispenseNextBlockAt:(CGPoint)position;

+ (STKLetterBlockDispenser*)dispenserWithLetters:(NSString*)letters colors:(NSArray*)colors physics:(CCPhysicsNode*)physics;

@end
