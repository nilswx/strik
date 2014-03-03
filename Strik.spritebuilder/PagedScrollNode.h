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

// The dot color for the page controls
@property (nonatomic) CCColor *pageControlDotColor;

// The dot color for the active page
@property (nonatomic) CCColor *acctivePageControlDotColor;

// The current page
@property (readonly) int currentPage;

- (id)initWithDataSource:(NSObject<PagedScrollNodeDataSource> *)dataSource;
+ (id)pagedScrollNodeWithDataSource:(NSObject<PagedScrollNodeDataSource> *)dataSource;

- (void)reload;

@end
