//
//  STKIncomingMessage.m
//  NetTest
//
//  Created by Nils on Jul 30, 2013.
//  Copyright (c) 2013 Nils. All rights reserved.
//

#import "STKIncomingMessage.h"

@interface STKIncomingMessage()

@property(nonatomic) NSData* buf;
@property(nonatomic) int index;

@end

@implementation STKIncomingMessage

- (id)initWithData:(NSData*)buf
{
    if(self = [super init])
    {
        self.buf = buf;
        _op = [self readByte];
    }
    
    return self;
}

- (bool)readBool
{
    const int8_t* b = [self.buf bytes];
    return (b[self.index++] == 1);
}

- (int8_t)readByte
{
    const int8_t* b = [self.buf bytes];
    
    return b[self.index++];
}

- (int16_t)readShort
{
    int8_t b[sizeof(int16_t)];
    [self.buf getBytes:&b range:NSMakeRange(self.index, sizeof(b))];
    self.index += sizeof(b);
    
    return CFSwapInt16BigToHost(*(int16_t*)b);
}

- (int32_t)readInt
{
    int8_t b[sizeof(int32_t)];
    [self.buf getBytes:&b range:NSMakeRange(self.index, sizeof(b))];
    self.index += sizeof(b);
    
    return CFSwapInt32BigToHost(*(int32_t*)b);
}

- (int64_t)readLong
{
    int8_t b[sizeof(int64_t)];
    [self.buf getBytes:&b range:NSMakeRange(self.index, sizeof(b))];
    self.index += sizeof(b);
    
    return CFSwapInt64BigToHost(*(int64_t*)b);
}

- (NSString*)readStr
{
    int16_t len = [self readShort];
    NSData* b = [self.buf subdataWithRange:NSMakeRange(self.index, len)];
    self.index += len;
    
    return [[NSString alloc] initWithData:b encoding:NSUTF8StringEncoding];
}

- (int)size
{
	return (int)[self.buf length];
}

@end
