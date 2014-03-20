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

#define SETTINGS_DISABLED_COLOR [CCColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f]
#define SETTINGS_ENABLED_COLOR [CCColor colorWithRed:241.0f/255.0f green:75.0f/255.0f blue:106.0f/255.0f]

@interface STKSettingsController()

@property (readonly) STKSettingsScene *settingsScene;

@end

@implementation STKSettingsController


- (void)sceneWillBegin
{
	// Set the correct color to the checkboxes for settings and ads
	[self colorSoundsCheckmark];
	[self colorAdFreeCheckMark];
	
	// Determine if facebook linked, if linked remove facebook settings container
	STKFacebookController *facebookController = self.core[@"facebook"];
	if(facebookController.isServerLinked)
	{
		[self.settingsScene removeFacebookLinkSettings];
	}
}

- (void)colorSoundsCheckmark
{
	if([STKSettings boolforKey:SETTINGS_KEY_SOUND])
	{
		[self colorButton:self.settingsScene.checkmarkSound withColor:SETTINGS_ENABLED_COLOR];
	}
	else
	{
		[self colorButton:self.settingsScene.checkmarkSound withColor:SETTINGS_DISABLED_COLOR];
	}
}

- (void)colorAdFreeCheckMark
{
	
}

- (void)colorButton:(CCButton *)button withColor:(CCColor *)color
{
	[button setBackgroundColor:color forState:CCControlStateHighlighted];
	[button setBackgroundColor:color forState:CCControlStateNormal];
	[button setBackgroundColor:color forState:CCControlStateSelected];
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
	[self colorSoundsCheckmark];
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
