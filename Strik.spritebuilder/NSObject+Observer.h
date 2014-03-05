//
//  NSObject+Obsersver.h
//  Strik
//
//  Created by Matthijn Dijkstra on 24/10/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STKModel;

@interface NSObject (Observer)

- (void)observeModel:(STKModel*)model;
- (void)observeModels:(NSArray*)models;
- (void)model:(STKModel*)model valueChangedForKey:(NSString*)key;

- (void)removeAsObserverForAllModels;
- (void)removeAsObserverForModel:(STKModel *)model;

@end
