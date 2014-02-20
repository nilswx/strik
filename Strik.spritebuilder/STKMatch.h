//
//  STKMatch.h
//  Strik
//
//  Created by Matthijn Dijkstra on 10/22/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

@class STKMatchPlayer, STKBoard, STKTile;

@interface STKMatch : STKModel

@property (nonatomic, assign) long matchId;

@property (nonatomic, strong) STKMatchPlayer *player;
@property (nonatomic, strong) STKMatchPlayer *opponent;

@property (nonatomic, assign) int gameTime;
@property (nonatomic, assign) int countdownTime;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, strong) STKBoard *board;

- (STKMatchPlayer *)playerByID:(int)ID;
- (BOOL)isPlayer:(int)ID;

@end
