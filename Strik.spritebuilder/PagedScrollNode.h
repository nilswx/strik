//
//  STKPagedScrollNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "ScrollNode.h"
#import "PagedScrollNodeDataSource.h"

@interface PagedScrollNode : ScrollNode

- (id)initWithDataSource:(NSObject<PagedScrollNodeDataSource> *)dataSource;
+ (id)pagedScrollNodeWithDataSource:(NSObject<PagedScrollNodeDataSource> *)dataSource;

- (void)reload;

@end
