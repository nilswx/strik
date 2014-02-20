//
//  STKCore.m
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKCore.h"

@interface STKCore()

@property(nonatomic) NSMutableDictionary* components;

@end

@implementation STKCore

- (id)init
{
	if(self = [super init])
	{
		NSLog(@"Core: initialized");
		self.components = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (NSString*)keyForComponent:(STKCoreComponent*)component
{
	NSString* key = [NSStringFromClass([component class]) substringFromIndex:@"STK".length];
	key = [key stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
	return [key lowercaseString];
}

- (void)installComponent:(STKCoreComponent*)component
{
	[self installComponent:component withKey:nil];
}

- (void)installComponent:(STKCoreComponent*)component withKey:(NSString*)key
{
	// Determine key
	if(!key)
	{
		key = [self keyForComponent:component];
	}
	
	// Install component under this key
	component.core = self;
	self.components[key] = component;
	NSLog(@"Core: installed %@", component);
	
	// Fire post-install events
	[component componentDidInstall];
}

- (void)uninstallComponent:(NSString*)key
{
	STKCoreComponent* component = self[key];
	if(component)
	{
		[self.components removeObjectForKey:key];
		[component componentDidUninstall];
	}
}

- (id)objectForKeyedSubscript:(id)key
{
	return self.components[key];
}

@end

@implementation STKCoreComponent

- (void)componentDidInstall { }
- (void)componentDidUninstall { }

@end