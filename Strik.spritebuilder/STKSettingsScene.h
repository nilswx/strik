//
//  STKSettings.h
//  Strik
//
//  Created by Matthijn Dijkstra on 25/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@interface STKSettingsScene : STKScene

// Remove the facebook link settings part
- (void)removeFacebookLinkSettings;

// The keys can be found in STKSettings.h
- (void)enableSetting:(BOOL)enable forKey:(NSString *)key;

@end
