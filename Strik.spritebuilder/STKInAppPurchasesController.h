//
//  STKPaymentController.h
//  Strik
//
//  Created by Nils on Dec 9, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKController.h"

#import <StoreKit/StoreKit.h>

@interface STKInAppPurchasesController : STKController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property(readonly) BOOL canMakePurchases;

- (void)refreshProducts;

- (void)purchaseProductWithIdentifier:(NSString*)identifier;

@end
