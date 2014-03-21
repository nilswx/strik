//
//  STKAdBanner.m
//  Strik
//
//  Created by Nils Wiersema on Mar 21, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAdBanner.h"

#import "STKScene.h"

@interface STKAdBanner()

@property ADBannerView* ad;
@property(readonly,nonatomic) STKScene* parentScene;

@end

@implementation STKAdBanner

- (void)onEnter
{
	[super onEnter];
	
	// I'm just a placeholder
	self.visible = NO;
	
	// Here comes the ad
	[self reload];
}

- (void)reload
{
	// Clear old ad
	[self clear];
	
	// Start loading the new ad
	self.ad = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
	self.ad.delegate = self;
	
	// Waiting...
	NSLog(@"Advertisement @ %@: reloading...", self.parentScene);
}

- (void)clear
{
	if(self.ad)
	{
		[self.ad removeFromSuperview];
		
		self.ad = nil;
	}
}

- (void)onExit
{
	[super onExit];
	
	[self clear];
}

- (void)removeFromParent
{
	[super removeFromParent];
	
	[self clear];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	/*
	 This method is triggered when an advertisement could not be loaded from the iAds system (perhaps due to a network connectivity issue). If you have already taken steps to only display an ad when it has successfully loaded it is not typically necessary to implement the code for this method. */
	
	NSLog(@"Advertisement @ %@: failed to load! (%@)", self.parentScene, error);
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	/* Introduced as part of the iOS 5 SDK, this method is triggered when the banner confirms that an advertisement is available but before the ad is downloaded to the device and is ready for presentation to the user. */
	
	// Get size of parent node
	CGSize parentSize = self.parent.boundingBox.size;
	
	// Position in the bottom of the parent
	CGSize size = self.boundingBox.size;
	self.ad.frame = CGRectMake((parentSize.width - size.width), (parentSize.height - size.height), size.width, size.height);
	
	// Show!
	[[[CCDirector sharedDirector] view] addSubview:self.ad];
	NSLog(@"Advertisement @ %@: loaded!", self.parentScene);
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	/*
	 This method is triggered when the user touches the iAds banner in your application. If the willLeave argument passed through to the method is YES then your application will be placed into the background while the user is taken elsewhere to interact with or view the ad. If the argument is NO then the ad will be superimposed over your running application in which case the code in this method may optionally suspend the screen output until the user returns.
	 
	 f the ad places the application into the background, the application will be resumed automatically once the action is completed.
	 To prevent the ad from performing the action, return NO from this method, though it is strongly recommended by Apple that you return YES if you wish to earn advertising revenue. */
	
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	/* This method is called when the ad view removes the ad content currently obscuring the application interface. If the application was paused during the ad view session this method can be used to resume activity: */
	
	NSLog(@"Advertisement @ %@: finished viewing!", self.parentScene);
}

- (STKScene*)parentScene
{
	return self.scene.children[0];
}

@end
