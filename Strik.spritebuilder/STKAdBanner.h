//
//  STKAdBanner.h
//  Strik
//
//  Created by Nils Wiersema on Mar 21, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

#import <iAd/iAd.h>

@interface STKAdBanner : CCNode <ADBannerViewDelegate>

- (void)reload;

@end
