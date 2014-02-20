//
//  STKMessageHandler.h
//  Strik
//
//  Created by Nils on Sep 29, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STKIncomingMessage;

@interface STKMessageHandler : NSObject

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, readonly) SEL selector;

- (void)handleMessage:(STKIncomingMessage*)message;

+ (STKMessageHandler*)handlerForSelector:(SEL)selector onTarget:(id)target;

@end

