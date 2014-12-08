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
#import "RatingViewController.h"

@interface ViewController ()<JSQDemoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylistConsoleLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *rejectButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *pendingRequestLabel;
@property (weak, nonatomic) IBOutlet UIButton *createSessionBtnOutlet;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForSessionStatus) name:@"applicationDidBecomeActive" object:nil];
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	if ([PFUser currentUser])
		[self checkForSessionStatus];
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
		
		self.stylistConsoleLabel.hidden = ![typeOfUser isEqualToString:@"stylist"];
		self.createSessionBtnOutlet.hidden = ![typeOfUser isEqualToString:@"customer"];
		
		NSString *firstName = [PFUser currentUser][@"firstName"];
		if(firstName.length)
		{
			self.welcomeLabel.hidden = NO;
			self.welcomeLabel.text = [NSString stringWithFormat:@"Hello, %@!", firstName];
		}
		else
			self.welcomeLabel.hidden = YES;
	}
}

-(void)checkForSessionStatus
{
	NSString *typeOfUser = [PFUser currentUser][@"typeOfUser"];
	
	self.stylistConsoleLabel.hidden = ![typeOfUser isEqualToString:@"stylist"];
	
	NSString *firstName = [PFUser currentUser][@"firstName"];
	if(firstName.length)
	{
		self.welcomeLabel.hidden = NO;
		self.welcomeLabel.text = [NSString stringWithFormat:@"Hello, %@!", firstName];
	}
	else
		self.welcomeLabel.hidden = YES;

	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
	
	PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
	
	if([typeOfUser isEqualToString:@"customer"])
		[query whereKey:@"customerObject" equalTo:[PFUser currentUser]];
	else
		[query whereKey:@"stylistObject" equalTo:[PFUser currentUser]];
	
	[query whereKey:@"status" notEqualTo:@"nomatch"];
	[query addDescendingOrder:@"createdAt"];
	[query includeKey:@"stylistObject"];
	[query includeKey:@"customerObject"];
	
	__weak typeof(self) weakSelf = self;
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		[SVProgressHUD dismiss];
		
		if (!error)
		{
			PFObject *sessionObj = [objects firstObject];
			NSLog(@"%@", sessionObj);
			
			self.pendingRequestLabel.hidden = YES;
			self.acceptBtnOutlet.hidden = YES;
			self.rejectButtonOutlet.hidden = YES;
			
			NSString *status = sessionObj[@"status"];
			if([status isEqualToString:@"chatting"])
			{
				NSLog(@"active session found. launching chat");
				
				DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
				vc.delegateModal = self;
				UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
				[weakSelf presentViewController:nc animated:YES completion:nil];
				vc.stylistObj = sessionObj[@"stylistObject"];;
				vc.convoObj = sessionObj;
				vc.custObj = sessionObj[@"customerObject"];
			}
			else if([status isEqualToString:@"matching"] && [typeOfUser isEqualToString:@"stylist"])
			{
				self.pendingRequestLabel.hidden = NO;
				self.acceptBtnOutlet.hidden = NO;
				self.rejectButtonOutlet.hidden = NO;
				self.pendingRequestLabel.text = @"You have an incoming session request.";
			}
		}
		else {
			NSLog(@"checkForSessionStatus Error: %@ %@", error, [error userInfo]);
		}
	}];
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
	[self dismissViewControllerAnimated:YES completion:^{
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle:nil];
		UINavigationController *ratingVC = [storyboard instantiateViewControllerWithIdentifier:@"RatingVCNav"];
//		[self.navigationController pushViewController:ratingVC animated:YES];
//		ratingVC.navigationItem.backBarButtonItem
		[self presentViewController:ratingVC animated:YES completion:nil];
	}];
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

- (IBAction)tappedAcceptRequestBtn:(id)sender {
	[self saveStylistResponse:YES];
}


- (IBAction)tappedRejectRequestBtn:(id)sender {
	[self saveStylistResponse:NO];
}


- (void)saveStylistResponse:(bool)stylistResponse
{
	if(![PFUser currentUser])
		return;
	
	NSString *requestID = @"JywVRoKAzy";
	bool isAccepted = stylistResponse;
	
	[PFCloud callFunctionInBackground:@"respondRequest"
					   withParameters:@{@"requestID":requestID, @"isAccepted":[NSNumber numberWithBool:isAccepted]}
								block:^(NSString *result, NSError *error) {
									if (!error) {
										NSLog(@"respondRequest result:%@", result);
									}
									else
									{
										NSLog(@"respondRequest error:%@", error);
									}
								}];
	
}

@end
