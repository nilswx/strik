//
//  RC4.h
//  Strik
//
//  Created by Nils on Oct 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RC4 : NSObject

- (NSData*)cipherData:(NSData*)data;
- (void)cipherMutableData:(NSMutableData*)data;

+ (RC4*)forKeyData:(NSData*)key;

@end
