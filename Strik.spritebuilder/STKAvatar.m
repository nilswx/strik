//
//  STKAvatar.m
//  Strik
//
//  Created by Matthijn on Feb 23, 2014.
//  Copyright (c) 2014 Indev. All rights reserved.
//

#import "STKAvatar.h"

@interface STKAvatar()

@end

@implementation STKAvatar

- (id)initWithAvatarIdentifier:(NSString *)identifier
{
	if(self = [super init])
	{
		self.identifier = identifier;
	}
	return self;
}

+ (STKAvatar*)avatarWithIdentifier:(NSString*)identifier
{
	return [[STKAvatar alloc] initWithAvatarIdentifier:identifier];
}

- (void)fetchAvatarWithCallback:(AvatarFetchResultBlock)callback
{
	// All avatars are stored in here, so we only need to load them once (from disk or internet)
	static NSMutableDictionary *fetchedAvatars = nil;
	if(!fetchedAvatars)
	{
		fetchedAvatars = [NSMutableDictionary dictionary];
	}
	
	// First try to fetch it from the ealier fetched avatars
	CCTexture *avatarTexture = [fetchedAvatars objectForKey:self.identifier];

	// It was loaded before
	if(avatarTexture)
	{
		// Callback to caller with avatar
		callback(avatarTexture, self.avatarType);
	}
	// It was not loaded before
	else
	{
		// Determine type (e.g normal avatar, of facebook avatar)
		
		// It is a facebook type avatar
		if(self.avatarType == AvatarTypeProfile)
		{
			// Fetching remote? Don't do that on the main thread
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
				
				// Get facebook ID from avatar identifier
				double facebookID = [[self.identifier substringFromIndex:1] doubleValue];
				
				// Fetch the contents of the URL create an image out of it
				NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%.0f/picture?width=200&height=200", facebookID]];
				NSData *data = [NSData dataWithContentsOfURL:url];
				UIImage *profileImage = [UIImage imageWithData:data];
				
				// Only go on if we can create an image
				if(profileImage)
				{
					// Going back on main thread here. All UI must go on main thread
					dispatch_async(dispatch_get_main_queue(), ^{
						
						// Create a texture from the fetched image
						CCTexture *avatarTexture = [[CCTexture alloc] initWithCGImage:profileImage.CGImage contentScale:2];
						
						// Cache it
						[fetchedAvatars setObject:avatarTexture forKey:self.identifier];
						
						// And call the callback with texture
						callback(avatarTexture, self.avatarType);
					});
				}
			});
		}
		// It can be loaded from disk
		else
		{
			// Get it's path
			NSString *avatarPath = [NSString stringWithFormat:@"Global/Images/Avatars/%d.png", [self.identifier intValue]];
			
			// Load the texture from disk
			avatarTexture = [CCTexture textureWithFile:avatarPath];
				
			// Add to cache
			[fetchedAvatars setObject:avatarTexture forKey:self.identifier];
			
			// And callback to caller with avatar
			callback(avatarTexture, self.avatarType);
		}
		
	}
	
}

- (AvatarType)avatarType
{
	if([[self.identifier substringToIndex:1] isEqualToString:@"f"])
	{
		return AvatarTypeProfile;
	}
	return AvatarTypeClient;
}

@end
