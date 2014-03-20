//
//  STKCore.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
// 

#import <Foundation/Foundation.h>

@class STKCoreComponent;

@interface STKCore : NSObject

- (void)installComponent:(STKCoreComponent*)component;

- (void)installComponent:(STKCoreComponent*)component withKey:(NSString*)key;

- (void)uninstallComponent:(NSString*)key;

- (id)objectForKeyedSubscript:(id)key;

@end

@interface STKCoreComponent : NSObject

@property STKCore *core;

- (void)componentDidInstall;

- (void)componentDidUninstall;

@end
