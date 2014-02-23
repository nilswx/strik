//
//  CCNode+ClipVisit.h
//  Strik
//
//  Created by Matthijn Dijkstra on 25/12/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "CCNode.h"

@interface CCNode (ClipVisit)

-(void)preVisitWithClippingRect:(CGRect)rect;
-(void)postVisit;

@end
