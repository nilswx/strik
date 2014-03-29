//
//  STKAudioController.h
//  Strik
//
//  Created by Nils on Nov 21, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKAudioController.h"

#import <OALSimpleAudio.h>
#import "STKSettings.h"

#define BACKGROUND_MUSIC_VOLUME 0.3f

@interface STKAudioController()

@property(nonatomic) OALSimpleAudio* audio;
@property(nonatomic) int fxpitch;

@property NSString* currentMusicName;

@end

@implementation STKAudioController

- (id)init
{
	if(self = [super init])
	{
		self.audio = [OALSimpleAudio sharedInstance];
		self.audio.bgVolume = BACKGROUND_MUSIC_VOLUME;
		
		NSLog(@"Audio: initialized OpenAL engine (bg=%f)", self.audio.bgVolume);
	}
	
	return self;
}

- (void)pauseAudio
{
	if(!self.audio.paused)
	{
		self.audio.paused = YES;
		
		NSLog(@"Audio: paused ALL audio");
	}
}

- (void)resumeAudio
{
	if(self.audio.paused)
	{
		self.audio.paused = NO;
		
		NSLog(@"Audio: resumed ALL audio");
	}
}

- (void)playMusicWithName:(NSString*)musicName
{
	if([STKSettings boolforKey:SETTINGS_KEY_SOUND])
	{
		// Already playing?
		if([musicName isEqual:self.currentMusicName])
		{
			// Don't re-start it, that sounds like suck. Stop it first, then we'll talk
			return;
		}
		
		// Please stop the music
		[self stopMusic];
		
		// Give it a spin (preloads if needed)
		NSString* fileName = [NSString stringWithFormat:@"audio/music/%@.mp3", musicName];
		if([self.audio playBg:fileName loop:YES])
		{
			self.currentMusicName = musicName;
			
			NSLog(@"Audio: now bg playing '%@'", self.currentMusicName);
		}
	}
}

- (void)stopMusic
{
	if(self.audio.bgPlaying)
	{
		NSLog(@"Audio: stopping bg '%@'", self.currentMusicName);
		
		self.currentMusicName = nil;
		
		[self.audio stopBg];
	}
}

- (void)playEffectWithName:(NSString*)effectName
{
	[self playEffectWithName:effectName pitch:1.0];
}

- (void)playEffectWithName:(NSString*)effectName pitch:(float)pitch
{
	if([STKSettings boolforKey:SETTINGS_KEY_SOUND])
	{
		NSString* fileName = [NSString stringWithFormat:@"audio/sfx/%@.caf", effectName];
		
		[self.audio playEffect:fileName volume:self.audio.effectsVolume pitch:pitch pan:0 loop:NO];
	}
}

@end
