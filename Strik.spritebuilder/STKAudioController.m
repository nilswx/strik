//
//  STKAudioController.h
//  Strik
//
//  Created by Nils on Nov 21, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKAudioController.h"
#import <AVFoundation/AVFoundation.h>

#import <OALSimpleAudio.h>

#define BACKGROUND_MUSIC_VOLUME 0.3f

@interface STKAudioController()

@property(nonatomic) OALSimpleAudio* audio;

@end

@implementation STKAudioController

- (id)init
{
	if(self = [super init])
	{
		self.audio = [OALSimpleAudio sharedInstance];
		self.audio.bgVolume = BACKGROUND_MUSIC_VOLUME;
	}
	
	return self;
}

- (void)pauseAudio
{
	[self pauseMusic];
}

- (void)resumeAudio
{
	[self resumeMusic];
}

- (void)playMusicWithName:(NSString*)name
{
	// Already playing?
	if([name isEqual:self.currentMusicName])
	{
		// Don't re-start it, that sounds like suck. Stop it first, then we'll talk
		return;
	}
	
	// Please stop the music
	[self stopMusic];
	
	// Attempt to preload, then resume
	if([self.audio preloadBg:[NSString stringWithFormat:@"%@.mp3", name]])
	{
		_currentMusicName = name;
		[self resumeMusic];
	}
}

- (void)pauseMusic
{
	if(self.audio.bgPlaying && !self.audio.bgPaused)
	{
		NSLog(@"Music: pausing '%@'", self.currentMusicName);

		self.audio.bgPaused = YES;
	}
}

- (void)resumeMusic
{
	if(self.audio.bgPaused)
	{
		self.audio.bgPaused = NO;
	}
	else if(!self.audio.bgPlaying)
	{
		[self.audio playBgWithLoop:YES];
	}
	
	NSLog(@"Music: now playing '%@'", self.currentMusicName);
}

- (void)stopMusic
{
	if(self.audio.bgPlaying)
	{
		NSLog(@"Music: stopping '%@'", self.currentMusicName);
		
		[self.audio stopBg];
	}
}

@end
