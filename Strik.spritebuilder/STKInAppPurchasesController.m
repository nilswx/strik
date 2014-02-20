//
//  STKPaymentController.m
//  Strik
//
//  Created by Nils on Dec 9, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKInAppPurchasesController.h"

#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"

@interface STKInAppPurchasesController()

@property NSMutableDictionary* products;

@end

@implementation STKInAppPurchasesController

- (void)componentDidInstall
{
	// For storing products
	self.products = [NSMutableDictionary new];
	
	// Request server's IAPs
	[self routeNetMessagesOf:IN_APP_PURCHASE_PRODUCTS to:@selector(handleInAppPurchaseProducts:)];
	[self routeNetMessagesOf:IN_APP_PURCHASE_DELIVERED to:@selector(handleInAppPurchaseDelivered:)];
}

- (void)refreshProducts
{
	// Register as payment queue observer
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	// Ask the products
	[self sendNetMessage:[STKOutgoingMessage withOp:GET_IN_APP_PURCHASE_PRODUCTS]];
}

- (void)handleInAppPurchaseProducts:(STKIncomingMessage*)msg
{
	int amount = [msg readInt];
	
	NSMutableSet* identifiers = [NSMutableSet setWithCapacity:amount];
	for(int i = 0; i < amount; i++)
	{
		[identifiers addObject:[msg readStr]];
	}
	
	[self requestAvailableProductsWithIdentifiers:identifiers];
}

- (void)handleInAppPurchaseDelivered:(STKIncomingMessage*)msg
{
	// Determine transaction ID
	NSString* transactionId = [NSString stringWithFormat:@"%lld", [msg readLong]];
	NSLog(@"IAP: server says transaction #%@ was delivered!", transactionId);
	
	// Finish this transaction
	for(SKPaymentTransaction* transaction in [[SKPaymentQueue defaultQueue] transactions])
	{
		if([transaction.transactionIdentifier isEqual:transactionId])
		{
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
			
			NSLog(@"IAP: finished #%@", transactionId);
			return;
		}
	}
}

- (void)requestAvailableProductsWithIdentifiers:(NSSet*)identifiers
{
	NSLog(@"IAP: getting SKProducts for %d identifiers", identifiers.count);

	// Request async...
	SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response
{
	// Clear old products
	[self.products removeAllObjects];
	
	// Add them to the map
	for(SKProduct* product in response.products)
	{
		self.products[product.productIdentifier] = product;
		
		NSLog(@"IAP: found product %@: '%@' for %0.2f",
			  product.productIdentifier,
			  product.localizedTitle,
			  product.price.floatValue);
	}
}

- (void)request:(SKRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"IAP: could not load products, %@", error);
}


- (void)purchaseProductWithIdentifier:(NSString*)identifier
{
	// Get product
	SKProduct* product = self.products[identifier];
	if(product)
	{
		NSLog(@"IAP: purchasing '%@'", product.productIdentifier);
		
		// Issue purchase...
		SKPayment* payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		NSLog(@"IAP: unknown product '%@'", identifier);
	}
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions
{
    for(SKPaymentTransaction* transaction in transactions)
	{
		switch(transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
			{
				NSLog(@"IAP: purchased %@! (%@)", transaction.transactionIdentifier, transaction.payment.productIdentifier);
				
				// Get signed receipt
				NSString* receipt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
				
				// Redeem it at the server
				STKOutgoingMessage* msg = [STKOutgoingMessage withOp:REDEEM_IN_APP_PURCHASE];
				[msg appendStr:receipt];
				[self sendNetMessage:msg];
			}
			break;
				
			case SKPaymentTransactionStateFailed:
			{
				NSLog(@"IAP: failed %@! (%@)", transaction.transactionIdentifier, transaction.error);
				
				[queue finishTransaction:transaction];
			}
			break;
				
			case SKPaymentTransactionStateRestored:
			{
				NSLog(@"IAP: restored %@?!", transaction.transactionIdentifier);
				
				[queue finishTransaction:transaction];
			}
			break;
		}
	}
}

- (BOOL)canMakePurchases
{
	return [SKPaymentQueue canMakePayments];
}

// Method to perform a purchase and get the receipt

@end
