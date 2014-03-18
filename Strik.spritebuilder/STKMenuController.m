//
//  STKMenuController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 18/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKMenuController.h"

#import "STKDirector.h"
#import "STKDirector+Modal.h"

#import "STKHomeController.h"

#import "STKAlertView.h"

#import "STKMatchController.h"

@interface STKMenuController()

@property (nonatomic, readonly) STKDirector *director;

@end

@implementation STKMenuController


#pragma mark User interation
- (void)onResumeButton:(CCButton *)sender
{
	[self.director hideOverlay];
}

- (void)onQuitButton:(CCButton *)sender
{
	
	STKAlertView *alertView = [STKAlertView confirmationWithTitle:NSLocalizedString(@"Are you sure?", nil) message:NSLocalizedString(@"If you forfeit you wil not receive any points for this match.", nil) target:self yesSelector:@selector(onConfirmedForfeit:) andNoSelector:@selector(onResumeButton:)];
	[alertView show];
}

- (void)onConfirmedForfeit:(id)sender
{
	STKMatchController *matchController = self.core[@"match"];
	[matchController exitMatch];
}

- (STKDirector *)director
{
	return self.core[@"director"];
}

@end
