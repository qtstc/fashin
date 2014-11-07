//
//  ViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 10/2/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "ViewController.h"

#import <Parse/Parse.h>
#import <SVProgressHUD.h>

#import "DemoMessagesViewController.h"

@interface ViewController ()<JSQDemoViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self checkForLoggedInUser:NO];
}

- (IBAction)logoutUser:(id)sender {
	[PFUser logOut];
	[self checkForLoggedInUser:YES];
}

- (void)checkForLoggedInUser:(bool)animated
{
	if (![PFUser currentUser])
	{
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle:nil];
		UINavigationController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavController"];
		[self presentViewController:loginVC animated:animated completion:nil];
	}
}

- (IBAction)testMessagingUITapped:(id)sender
{
	[PFAnalytics trackEvent:@"Session Opened"];
	
	DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
	vc.delegateModal = self;
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - Demo delegate

- (void)didDismissJSQDemoViewController:(DemoMessagesViewController *)vc
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createSessionTapped:(id)sender {
	
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

	PFObject *feedbackObj = [PFObject objectWithClassName:@"Requests"];
	feedbackObj[@"customer"] = @"Rajat";
	feedbackObj[@"stylist"] = @"Courtney";
	feedbackObj[@"status"] = @"test_finished";
	
	[feedbackObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		[SVProgressHUD dismiss];
		
		if(succeeded)
		{
			[PFAnalytics trackEvent:@"Rating Provided"];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		else
		{
			[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Coulnd't save feedback. Please tap Done again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
			NSLog(@"feedback save error: %@", error);
		}
	}];
	
}

@end
