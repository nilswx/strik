//
//  STKAvatar.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

@interface STKAvatar : STKModel

@property (nonatomic, copy) NSString *hat; // Birthday hat!
@property (nonatomic, copy) NSString *hair;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *eyes;
@property (nonatomic, copy) NSString *mouth;
@property (nonatomic, copy) NSString *shirt;
@property (nonatomic, copy) NSString *background;

+ (STKAvatar*)avatarFromString:(NSString*)string;

@end
