//
//  Helpers.h
//  Strik
//
//  Created by Matthijn Dijkstra on 27/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#pragma mark screen size helpers

static inline BOOL screen_height(int height) { return ([UIScreen mainScreen].bounds.size.height == height); }

static inline BOOL screen_height_greater(int height) { return ([UIScreen mainScreen].bounds.size.height > height); }
static inline BOOL screen_height_greater_or_equal(int height) { return (screen_height_greater(height) || screen_height(height)); }

static inline BOOL screen_height_less(int height) { return ([UIScreen mainScreen].bounds.size.height < height); }
static inline BOOL screen_height_less_or_equal(int height) { return (screen_height_less(height) || screen_height(height)); }