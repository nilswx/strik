//
//  STKSettings.h
//  Strik
//
//  Created by Matthijn Dijkstra on 28/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTINGS_KEY_SOUND @"sound"
#define SETTINGS_KEY_LANGUAGE @"language"

@interface STKSettings : NSObject

+ (void)loadSettings;

+ (void)setObject:(id)object forKey:(NSString *)key;
+ (id)objectForkey:(NSString *)key;

+ (void)setBool:(BOOL)boolean forKey:(NSString *)key;
+ (BOOL)boolforKey:(NSString *)key;

@end
