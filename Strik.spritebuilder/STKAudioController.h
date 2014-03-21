//
//  STKAudioController.h
//  Strik
//
//  Created by Nils on Nov 21, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKCore.h"

@interface STKAudioController : STKCoreComponent

@property(nonatomic,readonly) NSString* currentMusicName;

- (void)pauseAudio;

- (void)resumeAudio;

- (void)playMusicWithName:(NSString*)name;

- (void)stopMusic;

@end
