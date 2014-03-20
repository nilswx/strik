//
//  STKScene.m
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKScene.h"

@implementation STKScene

- (NSString*)description
{
	return NSStringFromClass([self class]);
}

+ (Class)controllerClass
{
	NSString* className = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Scene" withString:@"Controller"];
	return NSClassFromString(className);
}

+ (NSString *)ccbFileName
{
	return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"STK" withString:@""];
}

- (void)dealloc
{
    [self removeAsObserverForAllModels];
	
	NSLog(@"Dealloced scene: %@", self);
}

#pragma mark Overrides for Cocos events
- (void)onEnter
{
	[self enter];
	[self.controller enter];
	[super onEnter];
}

- (void)onEnterTransitionDidFinish
{
	[self enterTransitionDidFinish];
	[self.controller enterTransitionDidFinish];
	[super onEnterTransitionDidFinish];
}

- (void)onExit
{
	[self exit];
	[self.controller exit];
	[super onExit];
}

- (void)onExitTransitionDidStart
{
	[self exitTransitionDidStart];
	[self.controller exitTransitionDidStart];
	[super onExitTransitionDidStart];
}

#pragma mark events
- (void)sceneWillBegin
{
	// Override me
}

- (void)sceneWillEnd
{
	// Override me
}

- (void)enter
{
	// Override me
}

- (void)enterTransitionDidFinish
{
	// Override me
}

- (void)exit
{
	// Override me
}

- (void)exitTransitionDidStart
{
	// Override me
}

- (void)sceneLoaded
{
	// Override me
}

@end
