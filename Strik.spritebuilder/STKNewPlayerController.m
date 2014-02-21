//
//  STKNewPlayerController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 20/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKNewPlayerController.h"

#import "STKFacebookController.h"
#import "STKClientController.h"
#import "STKAlertView.h"

#import "CCNode+Animation.h"

@implementation STKNewPlayerController

- (void)onFacebookYes:(CCButton *)sender
{
	// Great!
	STKFacebookController* facebook = self.core[@"facebook"];
	[facebook openSessionWithCallback:^()
	 {
		 // Let's connect to server, if Facebook was authorized, it will be linked with server after login
		 [self connectToServer];
	 }];
}

- (void)onFacebookNo:(CCButton *)sender
{
	// Nag the user once more
	STKAlertView *alertView = [STKAlertView confirmationWithTitle:NSLocalizedString(@"Are you sure?", nil) message:NSLocalizedString(@"Logging in with Facebook allows you to play against friends, see their progress and more!", nil) target:self yesSelector:@selector(onConfirmedFacebookYes:) andNoSelector:nil];
	[alertView show];
}

- (void)onConfirmedFacebookYes:(id)sender
{
	// Okay okay... Just proceed then
	[self connectToServer];
}

- (void)connectToServer
{
	// First reverse the animation, so it matches the next :)
	[self.scene runTimelineNamed:@"Reversed" withCallback:^{
		[self.core[@"client"] connectToServer];
	}];
}

@end
