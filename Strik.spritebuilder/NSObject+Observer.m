//
//  NSObject+Obsersver.m
//  Strik
//
//  Created by Matthijn Dijkstra on 24/10/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Observer.h"
#import "STKModel.h"

@interface NSObject()

@property(weak) NSMutableDictionary *models;

@end

@implementation NSObject (Observer)

- (NSString*)aliasForModel:(STKModel*)model
{
	return [[NSStringFromClass([model class]) substringFromIndex:[@"STK" length]] lowercaseString];
}

- (void)observeModel:(STKModel*)model
{
	[self observeModel:model onKeys:nil];
}

- (void)observeModel:(STKModel*)model onKeys:(NSArray*)keys
{
	// Lazily created dictionary of models
    if(!self.models)
    {
        self.models = [NSMutableDictionary dictionary];
    }
	
	// Determine alias (can be overridden by a scene for custom aliasing per model instance)
	NSString* alias = [self aliasForModel:model];
	
	// Model registered?
	if(!self.models[alias])
	{
		((NSMutableDictionary*)self.models)[alias] = model;
	}
	
	// What to observe?
	NSKeyValueObservingOptions options = (NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew);
	if(keys)
	{
		// Specified keys!
		for(id key in keys)
		{
			[model addObserver:self forKeyPath:key options:options context:nil];
		}
	}
	else
	{
		// ALL keys
		[model addObserverForAllProperties:self options:options context:nil];
	}
}

- (void)observeModels:(NSArray*)models
{
    for(STKModel *model in models)
    {
        [self observeModel:model];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
	if([object isKindOfClass:[STKModel class]])
	{
        // Build a selector so we can call the correct method for this specific object and key directly
        NSString *shortName = [object shortName];
        NSString *keyName = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[keyPath substringToIndex:1] uppercaseString]];

        SEL modelAndKeySpecificSelector = NSSelectorFromString([NSString stringWithFormat:@"%@:valueChangedFor%@:", shortName, keyName]);

        // Does it respond to the direct selector?
        if([self respondsToSelector:modelAndKeySpecificSelector])
        {
            id value = [object valueForKey:keyPath];
            [self performSelector:modelAndKeySpecificSelector withObject:object withObject:value];
        }
        else
        {
            // Maybe there is a specific one for this model
            SEL modelSpecificSelector = NSSelectorFromString([NSString stringWithFormat:@"%@:valueChangedForKey:", shortName]);
            if([self respondsToSelector:modelSpecificSelector ])
            {
                [self performSelector:modelSpecificSelector withObject:object withObject:keyPath];
            }
            // Nothing there, revert to the good ol' default
            else
            {
                [self model:object valueChangedForKey:keyPath];
            }
        }
	}
}

- (void)model:(STKModel*)model valueChangedForKey:(NSString*)key { }

- (void)removeAsObserverForAllModels
{
	for(STKModel* model in [self.models allValues])
	{
		[model removeObserverForAllProperties:self];
	}
	[((NSMutableDictionary*)self.models) removeAllObjects];
}

- (void)removeAsObserverForModel:(STKModel *)model
{
	NSString *alias = [self aliasForModel:model];
	if([self.models valueForKey:alias])
	{
		[model removeObserverForAllProperties:self];
	}
}

- (void)setModels:(NSDictionary *)models
{
    objc_setAssociatedObject(self, @selector(models), models, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)models
{
    return objc_getAssociatedObject(self, @selector(models));
}

@end
