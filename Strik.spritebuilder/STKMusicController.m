//
//  STKMusicController.m
//  Strik
//
//  Created by Nils on Nov 21, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKMusicController.h"
#import <AVFoundation/AVFoundation.h>

#define BACKGROUND_MUSIC_VOLUME 0.3f

@interface STKMusicController()

@property(nonatomic) BOOL isLooping;
@property(nonatomic) AVAudioPlayer* music;

@end

@implementation STKMusicController

- (void)disableAudio
{
	[self pauseMusic];
	
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)enableAudio
{
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	
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
	
	// Find music file
	NSURL* file = [[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"];
	
	// Attempt to load player
	NSError* error;
	self.music = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&error];

	// Success?
	if(!error)
	{
		// Loaded!
		_currentMusicName = name;
		
		// Adjust volume
		self.music.volume = BACKGROUND_MUSIC_VOLUME;
		
		// Induce infinite ear cancer
		self.music.numberOfLoops = -1;
		[self resumeMusic];
	}
}

- (void)pauseMusic
{
	if(self.music)
	{
		NSLog(@"Music: pausing '%@'", self.currentMusicName);

		[self.music pause];
	}
}

- (void)resumeMusic
{
	if(self.music)
	{
		NSLog(@"Music: now playing '%@'", self.currentMusicName);

		[self.music play]; // TODO: fade in
	}
}

- (void)stopMusic
{
	if(self.music)
	{
		NSLog(@"Music: stopping '%@'", self.currentMusicName);
		
		[self.music stop]; // TODO: fade out
		self.music = nil;
	}
}

- (BOOL)isPlayingMusic
{
	return (BOOL)self.music;
}

@end
