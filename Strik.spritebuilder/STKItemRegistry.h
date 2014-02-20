//
//  STKItemTypeRegistry.h
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKController.h"

@class STKItemType;

@interface STKItemRegistry : STKController

- (STKItemType*)typeForID:(int)typeId;

- (STKItemType*)typeForCode:(NSString*)code;

+ (STKItemRegistry*)sharedRegistry;

@end
