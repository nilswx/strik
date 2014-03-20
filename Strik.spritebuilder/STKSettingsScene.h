//
//  STKSettings.h
//  Strik
//
//  Created by Matthijn Dijkstra on 25/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"


@interface STKSettingsScene : STKScene

@property CCButton *flagUS;
@property CCButton *flagNL;
@property CCButton *flagES;

@property CCButton *checkmarkSound;
@property CCButton *checkmarkAdFree;

// The facebook link container (will be removed when facebook is linked)
@property CCNode *facebookLinkContainer;

@property CCButton *facebookButton;


// Remove the facebook link settings part
- (void)removeFacebookLinkSettings;

@end
