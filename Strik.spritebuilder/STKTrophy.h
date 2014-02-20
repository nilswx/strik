//
//  STKTrophy.h
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKItemType.h"

@interface STKTrophy : STKItemType

+ (STKTrophy*)trophyWithID:(int)typeId andCode:(NSString*)code;

@end
