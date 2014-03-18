//
//  STKStack.h
//  Strik
//
//  Created by Matthijn Dijkstra on 7/29/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStack : NSObject

@property (nonatomic, readonly) int count;
@property (nonatomic, readonly) NSArray *internalData;

- (void)pushObject: (id)object;
- (id)peek;
- (id)peekAtIndex:(int)index;
- (id)pop;
- (void)clear;

+ (id)stack;

@end