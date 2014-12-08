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
	else
	{
		//check for type of user
		NSString *typeOfUser = [PFUser currentUser][@"typeOfUser"];
		[[NSUserDefaults standardUserDefaults] setObject:typeOfUser forKey:@"typeOfUser"];
		[[NSUserDefaults standardUserDefaults] synchronize];
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
	
	if(![PFUser currentUser])
		return;
	
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

	PFObject *requestObj = [PFObject objectWithClassName:@"Requests"];
	requestObj[@"customerObject"] = [PFUser currentUser];
	requestObj[@"status"] = @"matching";
	//matching, chatting, ended, nomatch
	
	[requestObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		[SVProgressHUD dismiss];
		
		if(succeeded)
		{
			NSString *requestID = requestObj.objectId;
			NSLog(@"create new session success: %@", requestID);

			[PFCloud callFunctionInBackground:@"pingStylist"
							   withParameters:@{@"requestID":requestID}
										block:^(NSString *result, NSError *error) {
											if (!error) {
												NSLog(@"result:%@", result);
											}
											else
											{
												NSLog(@"pingStylist error:%@", error);
											}
										}];
		}
		else
		{
			[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Coulnd't create a new request. Please try again later." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
			NSLog(@"create new session save error: %@", error);
		}
	}];
	
}


- (IBAction)tappedProfileButton:(id)sender {
	
}



@end
