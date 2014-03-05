//
//  Fluent.h
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fluent : NSObject

// Returns a "fluent string"
// Example {actor} {action} {subject} {time}
// E.g in en {matthijn} {reached} {level 9} {just now}
// Todo: localize
+ (NSString *)fluentStringWithActor:(NSString *)actor action:(NSString *)action subject:(NSString *)subject atTime:(NSDate *)time;

@end
