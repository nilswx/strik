//
//  STKExperience.h
//  Strik
//
//  Created by Nils Wiersema on Mar 22, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKLevel : NSObject

@property(readonly) int num;
@property(readonly) int beginXP;
@property(readonly) STKLevel* next;
@property(readonly) int totalToNext;

- (int)progressToNext:(int)currentXP;

+ (STKLevel*)level:(int)num beginXP:(int)beginXP;

@end

@interface STKExperience : NSObject

+ (void)setLevels:(NSArray*)levels;
+ (STKLevel*)levelForXP:(int)xp;

@end
