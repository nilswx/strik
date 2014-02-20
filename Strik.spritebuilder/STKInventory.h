//
//  STKInventory.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

@class STKItem;

@interface STKInventory : STKModel

@property(nonatomic) int balance;
@property(nonatomic) NSMutableDictionary* items;

@end
