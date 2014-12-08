//
//  ProfileViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 12/8/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "ProfileViewController.h"

#import <CardIO.h>
#import "PayPalMobile.h"

@interface ProfileViewController () <CardIOPaymentViewControllerDelegate, PayPalFuturePaymentDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cardInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *paypalInfoLabel;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self preConfigPaypal];
}

-(void)preConfigPaypal{
	// Set up payPalConfig
	_payPalConfig = [[PayPalConfiguration alloc] init];
	_payPalConfig.acceptCreditCards = YES;
	_payPalConfig.merchantName = @"Fashin Inc.";
	_payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"http://www.fashin.co"];
	_payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"http://www.fashin.co"];
	
	_payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
	
	
	// Setting the payPalShippingAddressOption property is optional.
	//
	// See PayPalConfiguration.h for details.
	
//	_payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
	
	// Do any additional setup after loading the view, typically from a nib.
	
//	self.successView.hidden = YES;
	
//	 use default environment, should be Production in real life
//	self.environment = PayPalEnvironmentNoNetwork;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[CardIOUtilities preload];
	
	//[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
	
	NSString *currentCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"usercc"];
	if(currentCard.length)
		self.cardInfoLabel.text = currentCard;
	else
		self.cardInfoLabel.text = @"No card";
	
	NSString *currentPaypal = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpaypal"];
	if(currentPaypal.length)
		self.paypalInfoLabel.text = currentPaypal;
	else
		self.paypalInfoLabel.text = @"Not authorised";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedDoneButton:(id)sender {
	//MARK_TODO: save changes first
	
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedCancelButton:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)captureCardTapped:(id)sender {
	CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
	scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
	NSLog(@"Scan succeeded with info: %@", info);
	// Do whatever needs to be done to deliver the purchased items.
	[self dismissViewControllerAnimated:YES completion:nil];
	
	NSString *response = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
	NSLog(@"cardio response: %@", response);
	
	NSString *currentCard = [NSString stringWithFormat:@"using xx%@", [info.redactedCardNumber substringWithRange:NSMakeRange(info.redactedCardNumber.length - 4, 4)]];
	[[NSUserDefaults standardUserDefaults] setObject:currentCard forKey:@"usercc"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	self.cardInfoLabel.text = currentCard;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
	//NSLog(@"User cancelled scan");
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tappedPaypalButton:(id)sender
{
	PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
	[self presentViewController:futurePaymentViewController animated:YES completion:nil];
}

#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
				didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
	//NSLog(@"PayPal Future Payment Authorization Success!");
	NSString *result  = [futurePaymentAuthorization description];
//	NSLog(@"paypal result:%@", result);
	
//	[self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
	[self dismissViewControllerAnimated:YES completion:nil];
	
	NSString *currentPaypal = @"Authorised";
	[[NSUserDefaults standardUserDefaults] setObject:currentPaypal forKey:@"userpaypal"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
//	NSLog(@"PayPal Future Payment Authorization Canceled");
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
	// TODO: Send authorization to server
//	NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}

@end
