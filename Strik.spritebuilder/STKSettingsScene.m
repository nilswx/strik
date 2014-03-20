//
//  STKSettings.m
//  Strik
//
//  Created by Matthijn Dijkstra on 25/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSettingsScene.h"
#import "STKSettings.h"

#define SETTINGS_DISABLED_COLOR [CCColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f]
#define SETTINGS_ENABLED_COLOR [CCColor colorWithRed:241.0f/255.0f green:75.0f/255.0f blue:106.0f/255.0f]

@interface STKSettingsScene()

@property CCButton *flagUS;
@property CCButton *flagNL;
@property CCButton *flagES;

@property CCButton *checkmarkSound;
@property CCButton *checkmarkAdFree;

// The facebook link container (will be removed when facebook is linked)
@property CCNode *facebookLinkContainer;

@property CCButton *facebookButton;

@end

@implementation STKSettingsScene

- (void)removeFacebookLinkSettings
{
	// Get the height of the facebook link settings
	CGFloat facebookSettingsHeight = self.facebookLinkContainer.contentSizeInPoints.height;
	
	// Remove from parent
	[self.facebookLinkContainer removeFromParent];
	
	// Decrease height of settings so there is no big gaping hole.
	self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height - facebookSettingsHeight + 2); // It looks odd without the extra pixels
}

- (void)enableSetting:(BOOL)enable forKey:(NSString *)key
{
	
	if([key isEqualToString:SETTINGS_KEY_SOUND])
	{
		[self enableCheckMark:self.checkmarkSound enabled:enable];
	}
	else if([key isEqualToString:SETTINGS_KEY_HIDE_ADS])
	{
		[self enableCheckMark:self.checkmarkAdFree enabled:enable];
	}
}


- (void)enableCheckMark:(CCButton *)checkMark enabled:(BOOL)enabled
{
	if(enabled)
	{
		[self colorButton:checkMark withColor:SETTINGS_ENABLED_COLOR];
	}
	else
	{
		[self colorButton:checkMark withColor:SETTINGS_DISABLED_COLOR];
	}
}

- (void)colorButton:(CCButton *)button withColor:(CCColor *)color
{
	[button setBackgroundColor:color forState:CCControlStateHighlighted];
	[button setBackgroundColor:color forState:CCControlStateNormal];
	[button setBackgroundColor:color forState:CCControlStateSelected];
}

@end
