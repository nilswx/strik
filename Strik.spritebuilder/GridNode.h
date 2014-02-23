//
//  STKTableNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 13/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "ScrollNode.h"
#import "GridNodeDataSource.h"
#import "GridNodeDelegate.h"

@interface GridNode : ScrollNode

@property (nonatomic, weak) NSObject<GridNodeDelegate> *delegate;

- (id)initWithDataSource:(NSObject<GridNodeDataSource> *)dataSource;
+ (id)gridWithDataSource:(NSObject<GridNodeDataSource> *)dataSource;

// When changing the row and or column count, call this, so it wil be shown
- (void)reload;

@end
