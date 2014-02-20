//
//  STKModel.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKModel : NSObject

- (void)addObserverForAllProperties:(NSObject*)observer options:(NSKeyValueObservingOptions)options context:(void*)context;
- (void)removeObserverForAllProperties:(NSObject*)observer;

- (id)objectForKeyedSubscript:(id)key;

- (NSString *)shortName;

@end