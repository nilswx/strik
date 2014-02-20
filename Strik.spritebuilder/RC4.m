//
//  RC4.m
//  Strik
//
//  Created by Nils on Oct 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "RC4.h"

#define TABLE_SIZE 256
#define TABLE_SWAP(a,b) short t = _table[a]; _table[a] = _table[b]; _table[b] = t;

@interface RC4()
{
	int _i, _j;
	short _table[TABLE_SIZE];
}
@end

@implementation RC4

- (id)initWithKeyData:(NSData*)keyData
{
	if(self = [super init])
	{
		for(_i = 0; _i < TABLE_SIZE; _i++)
		{
			_table[_i] = _i;
		}
		const int8_t* key = keyData.bytes;
		for(_i = 0, _j = 0; _i < TABLE_SIZE; _i++)
		{
			_j = (((_j + _table[_i]) + key[_i % keyData.length])) % TABLE_SIZE;
			TABLE_SWAP(_i, _j);
		}
		_i = _j = 0;
	}
	
	return self;
}

- (NSData*)cipherData:(NSData*)data
{
    NSMutableData* copy = [NSMutableData dataWithBytes:data.bytes length:data.length];
    
    int8_t* bytes = [copy mutableBytes];
    for(int i = 0; i < copy.length; i++)
    {
		_i = (_i + 1) % TABLE_SIZE;
		_j = (_j + _table[_i]) % TABLE_SIZE;
		TABLE_SWAP(_i, _j);
        bytes[i] ^= (_table[(_table[_i] + _table[_j]) % TABLE_SIZE]);
    }
	
    return copy;
}

- (void)cipherMutableData:(NSMutableData*)data
{
    int8_t* bytes = [data mutableBytes];
    for(int i = 0; i < data.length; i++)
    {
		_i = (_i + 1) % TABLE_SIZE;
		_j = (_j + _table[_i]) % TABLE_SIZE;
		TABLE_SWAP(_i, _j);
        bytes[i] ^= (_table[(_table[_i] + _table[_j]) % TABLE_SIZE]);
    }
}

+ (RC4*)forKeyData:(NSData*)key
{
    return [[RC4 alloc] initWithKeyData:key];
}

@end
