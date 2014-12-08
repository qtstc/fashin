//
//  EmailLoginViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 10/3/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "EmailLoginViewController.h"

#import <Parse/Parse.h>

@interface EmailLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *connectModeSegmentedControl;

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self.emailTextField becomeFirstResponder];
}

- (IBAction)tappedGoButton:(id)sender
{
	//validate inputs
	if(!self.emailTextField.text.length || !self.passwordTextField.text.length)
	{
		[self showErrorWithString:@"Both email and password fields must be non empty"];
		return;
	}
	
	//MARK_TODO: impose password min length in production
	
	//proceed to login
	__weak typeof(self) weakSelf = self;
	if(self.connectModeSegmentedControl.selectedSegmentIndex == 0)
	{
		PFUser *user = [PFUser user];
		user.username = self.emailTextField.text;
		user.password = self.passwordTextField.text;
		user.email = self.emailTextField.text;
		user[@"typeOfUser"] = @"customer";
		
		[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		 {
			 if (!error) {
				 // Hooray! Let them use the app now.
				 [weakSelf dismissLoginVC];
			 } else {
				 NSString *errorString = [error userInfo][@"error"];
				 // Show the errorString somewhere and let the user try again.
				 [weakSelf showErrorWithString:errorString];
			 }
		 }];
	}
	else
	{
		[PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text
										block:^(PFUser *user, NSError *error)
		 {
			 if (user) {
				 // Hooray! Let them use the app now.
				 [weakSelf dismissLoginVC];
			 } else {
				 NSString *errorString = [error userInfo][@"error"];
				 // Show the errorString somewhere and let the user try again.
				 [weakSelf showErrorWithString:errorString];
			 }
		 }];
	}
}

-(void)dismissLoginVC{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showErrorWithString:(NSString *)errMsg
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:errMsg delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
	[alert show];
}

- (IBAction)tappedForgotPassword:(id)sender {
	//prompt for email first
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Enter email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
	alertView.tag = 2;
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView show];
	return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	UITextField * alertTextField = [alertView textFieldAtIndex:0];
	
	if(buttonIndex == 0 || alertTextField.text.length < 1)
		return;
	
	NSString *usersEmail = alertTextField.text;
//	NSLog(@"request pwd for %@", usersEmail);
	
	__weak typeof(self) weakSelf = self;
	[PFUser requestPasswordResetForEmailInBackground:usersEmail block:^(BOOL succeeded, NSError *error) {
		if(error)
		{
			NSString *errorString = [error userInfo][@"error"];
			[weakSelf showErrorWithString:errorString];
		}
	}];
}


@end
