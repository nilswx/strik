//
//  STKSettings.m
//  Strik
//
//  Created by Matthijn Dijkstra on 25/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSettingsScene.h"

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

@end
