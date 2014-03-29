//
//  STKSettingsController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 25/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSettingsController.h"
#import "STKSettings.h"
#import "STKSettingsScene.h"

#import "STKFacebookController.h"
#import "STKAudioController.h"

@interface STKSettingsController()

@property (readonly) STKSettingsScene *settingsScene;

@end

@implementation STKSettingsController


- (void)sceneWillBegin
{
	// Set the correct color to the checkboxes for settings and ads
	[self.settingsScene enableSetting:[STKSettings boolforKey:SETTINGS_KEY_SOUND] forKey:SETTINGS_KEY_SOUND];
	[self.settingsScene enableSetting:[STKSettings boolforKey:SETTINGS_KEY_HIDE_ADS] forKey:SETTINGS_KEY_HIDE_ADS];
	
	// Determine if facebook linked, if linked remove facebook settings container
	STKFacebookController *facebookController = self.core[@"facebook"];
	if(facebookController.isServerLinked)
	{
		[self.settingsScene removeFacebookLinkSettings];
	}
}

#pragma mark Button events
- (void)onFlagUSButton:(CCButton *)button
{
	
}

-(void)onFlagNLButton:(CCButton *)button
{
	
}

- (void)onFlagESButton:(CCButton *)button
{
	
}

- (void)onSoundButton:(CCButton *)button
{
	[STKSettings setBool:![STKSettings boolforKey:SETTINGS_KEY_SOUND] forKey:SETTINGS_KEY_SOUND];
	[self.settingsScene enableSetting:[STKSettings boolforKey:SETTINGS_KEY_SOUND] forKey:SETTINGS_KEY_SOUND];
	
	// Re-enable background music
	if([STKSettings boolforKey:SETTINGS_KEY_SOUND])
	{
		[self.core[@"audio"] playMusicWithName:MUSIC_BACKGROUND_MENU];
	}
	// Disable background music
	else
	{
		[self.core[@"audio"] stopMusic];
	}
}

- (void)onAdFreeButton:(CCButton *)button
{
	// Todo: This does nothing yet, don't think storing this setting in NSUserDefaults is a good idea though...
}

- (void)onFacebookButton:(CCButton *)button
{
	// Todo: Hide screen @ callback
	// Try to connect to facebook
	STKFacebookController *facebookController = self.core[@"facebook"];
	[facebookController openSessionWithCallback:nil];
}

#pragma mark getters and setters
- (STKSettingsScene *)settingsScene
{
	return (STKSettingsScene *)self.scene;
}

@end
