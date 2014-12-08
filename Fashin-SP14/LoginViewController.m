//
//  LoginViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 10/2/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "LoginViewController.h"

#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBarHidden = YES;
}

-(void)dismissLoginVC{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedSignInWithFB:(id)sender {
	
	NSArray *permissionsArray = [[NSArray alloc] initWithObjects:@"user_birthday",
								 @"email",
								 @"user_location",
								 nil];
	
	[PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
	{
		if (!user) {
			NSLog(@"Uh oh. The user cancelled the Facebook login.");
		} else if (user.isNew) {
			NSLog(@"User signed up and logged in through Facebook!");
			[self dismissLoginVC];
		} else {
			NSLog(@"User logged in through Facebook!");
			[self dismissLoginVC];
		}
	}];	
}

-(UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

@end
