//
//  ScrollNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 25/12/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "CCNode.h"

@interface ScrollNode : CCNode <UIScrollViewDelegate>

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) CCNode *content;

- (id)initWithContent:(CCNode *)content;
+ (id)scrollNodeWithContent:(CCNode *)content;

- (void)enableScrolling:(BOOL)enableScrolling;
- (CGRect)visibleFrame;

#pragma mark Protected
- (void)setupScrollView;

@end
