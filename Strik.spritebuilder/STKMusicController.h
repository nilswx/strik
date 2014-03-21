//
//  STKMusicController.h
//  Strik
//
//  Created by Nils on Nov 21, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKCore.h"

@interface STKMusicController : STKCoreComponent

@property(nonatomic,readonly) NSString* currentMusicName;
@property(nonatomic,getter=isPlayingMusic) BOOL isPlayingMusic;

- (void)disableAudio;

- (void)enableAudio;

- (void)playMusicWithName:(NSString*)name;

- (void)pauseMusic;

- (void)resumeMusic;

- (void)stopMusic;

@end
