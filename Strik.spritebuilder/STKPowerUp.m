//
//  STKPowerUp.m
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKPowerUp.h"

@implementation STKPowerUp

+ (STKPowerUp*)powerUpWithID:(int)typeId andCode:(NSString*)code
{
	return [[STKPowerUp alloc] initWithID:typeId andCode:code];
}

@end
