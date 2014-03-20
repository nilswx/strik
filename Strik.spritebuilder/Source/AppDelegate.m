/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"

#import "STKCore.h"
#import "STKDirector.h"
#import "STKInAppPurchasesController.h"
#import "STKFacebookController.h"
#import "STKClientController.h"
#import "STKScene.h"

#import "STKSettings.h"

#import "STKAvatar.h"

#import <Facebook.h>

@interface AppController()

@property STKCore *core;

@end

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Load the settings before everything else
	[STKSettings loadSettings];
	
	// Setup Cocos2D and Spritebuilder related settings
	// Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
	// Using CCClipping node so this has to be turned on
    [cocos2dSetup setObject:@GL_DEPTH24_STENCIL8_OES forKey:CCSetupDepthFormat];
		
	// Setup game structure
	[self setupCoreComponents];
	
	// Start cocos
	[self setupCocos2dWithOptions:cocos2dSetup];
	
    return YES;
}

- (void)setupCoreComponents
{
	self.core = [STKCore new];
	
	// Setup the STKDirector
	[self.core installComponent:[STKDirector new]];
	
	// In App Purchases
	//[self.core installComponent:[STKInAppPurchasesController new] withKey:@"iap"];
	
	// We also want Facebook
	[self.core installComponent:[STKFacebookController new]];
	
	// Plug client controller
	[self.core installComponent:[STKClientController new]];
}

- (CCScene*) startScene
{
    STKDirector *spielberg = self.core[@"director"];
	[spielberg setupBootstrapScene];
	
	return spielberg.cocosScene;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	// For Facebook web browser flow
    return [[FBSession activeSession] handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// YOU AND ME BABI WE BE NO NOTHING BUT MAMMAL
	[super applicationDidBecomeActive:application];
	
	// We need to properly handle activation of the application with regards to Facebook Login
	// (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
	[[FBSession activeSession] handleDidBecomeActive];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[super applicationDidReceiveMemoryWarning:application];
	
	// Clear any caches here :)
	[STKAvatar clearAvatarCache];
}

@end
