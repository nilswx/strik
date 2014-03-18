//
//  STKStack.m
//  Strik
//
//  Created by Matthijn Dijkstra on 7/29/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "NSStack.h"

@interface NSStack()

@property(nonatomic) NSMutableArray *stackData;

@end

@implementation NSStack

- (id)init
{
    if(self = [super init])
    {
        self.stackData = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)stack
{
    return [[NSStack alloc] init];
}

- (void)pushObject:(id)object
{
    [self.stackData addObject:object];
}

- (id)peek
{
    return [self peekAtIndex:(int)self.stackData.count -1];
}

- (id)peekAtIndex:(int)index
{
    if(self.stackData.count >= index)
    {
        return [self.stackData objectAtIndex:index];
    }
    return nil;
}

- (id)pop
{
    id item = [self peek];
    [self.stackData removeLastObject];
    return item;
}

- (int)count
{
    return (int)self.stackData.count;
}

- (void)clear {
	[self.stackData removeAllObjects];
}

- (NSString *)description
{
	return [self.stackData description];
}

@end