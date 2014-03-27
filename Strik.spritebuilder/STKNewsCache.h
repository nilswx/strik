//
//  STKNewsCache.h
//  Strik
//
//  Created by Nils Wiersema on Mar 27, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKController.h"

@interface STKNewsCache : STKController

@property(readonly) NSArray* items;

- (void)refreshNews;

@end
