//
//  ViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 10/2/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "ViewController.h"

#import <Parse/Parse.h>

@interface ViewController ()

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

@end
