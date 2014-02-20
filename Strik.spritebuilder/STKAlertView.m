//
//  STKAlertView.m
//  Strik
//
//  Created by Matthijn Dijkstra on 18/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKAlertView.h"

typedef NS_ENUM(int8_t, STKAlertButtonType)
{
	STKAlertButtonTypeCancel,
	STKAlertButtonTypeOK
};

@interface STKAlertView()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL okSelector;
@property (nonatomic, assign) SEL cancelSelector;

@end


@implementation STKAlertView

#pragma mark Initializers
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self  = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	return self;
}

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
	self = [self initWithTitle:title message:message cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"OK button alert")];
	return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message target:(id)target yesSelector:(SEL)yesSelector andNoSelector:(SEL)noSelector;
{
	self = [self initWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"No", @"No button alert") otherButtonTitles:NSLocalizedString(@"Yes", @"YES button alert")];
	if(self)
	{
		self.target = target;
		self.okSelector = yesSelector;
		self.cancelSelector = noSelector;
	}
	return self;
}

#pragma mark Init helpers
- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultValue:(NSString *)defaultValue target:(id)target okSelector:(SEL)okSelector andCancelSelector:(SEL)cancelSelector
{
	self = [self initWithTitle:title message:message cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button alert") otherButtonTitles:NSLocalizedString(@"OK", @"OK button alert")];
	if(self)
	{
		self.target = target;
		self.okSelector = okSelector;
		self.cancelSelector = cancelSelector;
		
		self.alertViewStyle = UIAlertViewStylePlainTextInput;
		UITextField *textField = [self textFieldAtIndex:0];
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		textField.placeholder = defaultValue;
	}
	return self;
}

+ (id)alertWithTitle:(NSString *)title andMessage:(NSString *)message
{
	return [[STKAlertView alloc] initWithTitle:title andMessage:message];
}

+ (id)confirmationWithTitle:(NSString *)title message:(NSString *)message target:(id)target yesSelector:(SEL)yesSelector andNoSelector:(SEL)noSelector
{
	return [[STKAlertView alloc] initWithTitle:title message:message target:target yesSelector:yesSelector andNoSelector:noSelector];
}

+ (id)promptWithTitle:(NSString *)title message:(NSString *)message defaultValue:(NSString *)defaultValue target:(id)target okSelector:(SEL)okSelector andCancelSelector:(SEL)cancelSelector
{
	return [[STKAlertView alloc] initWithTitle:title message:message defaultValue:defaultValue target:target okSelector:okSelector andCancelSelector:cancelSelector];
}

#pragma mark events;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// No need to handle normal alerts with just the "OK" button
	if(self.numberOfButtons > 1)
	{
		if(self.alertViewStyle == UIAlertViewStyleDefault)
		{
			[self handleConfirm:buttonIndex];
		}
		else if(self.alertViewStyle == UIAlertViewStylePlainTextInput)
		{
			[self handlePrompt:buttonIndex];
		}
	}
}

- (void)handleConfirm:(STKAlertButtonType)buttonIndex
{
	[self handleCallBackWithbuttonIndex:buttonIndex andValueToPass:nil];
}

- (void)handlePrompt:(STKAlertButtonType)buttonIndex
{
	UITextField *textField = [self textFieldAtIndex:0];
	[self handleCallBackWithbuttonIndex:buttonIndex andValueToPass:textField.text];
}

- (void)handleCallBackWithbuttonIndex:(STKAlertButtonType)buttonPressed andValueToPass:(id)valueToPass
{
	if(buttonPressed == STKAlertButtonTypeOK)
	{
		if(self.okSelector != nil)
		{
			[self.target performSelector:self.okSelector withObject:valueToPass];
		}
	}
	else
	{
		if(self.cancelSelector != nil)
		{
			[self.target performSelector:self.cancelSelector withObject:nil];
		}
	}
}

@end
