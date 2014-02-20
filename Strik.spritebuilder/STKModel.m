//
//  STKModel.m
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

#import <objc/runtime.h>

@implementation STKModel

- (void)addObserverForAllProperties:(NSObject*)observer options:(NSKeyValueObservingOptions)options context:(void*)context
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (size_t i = 0; i < count; ++i)
	{
        NSString* key = [NSString stringWithCString:property_getName(properties[i]) encoding:NSASCIIStringEncoding];
        [self addObserver:observer forKeyPath:key options:options context:context];
    }
    free(properties);
}

- (void)removeObserverForAllProperties:(NSObject*)observer
{
	unsigned int count;

	objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (size_t i = 0; i < count; ++i)
	{
        NSString* key = [NSString stringWithCString:property_getName(properties[i]) encoding:NSASCIIStringEncoding];
        [self removeObserver:observer forKeyPath:key];
    }
    free(properties);
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self valueForKey:key];
}

- (NSString *)shortName
{
    // Converts STKFooBarName to fooBarName
    NSString *name = [[[self class] description] substringFromIndex:3];
    return [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] lowercaseString]];
}

@end
