//
//  RatingViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 10/16/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "RatingViewController.h"

#import "EDStarRating.h"
#import <AVHexColor.h>
#import <Parse/Parse.h>
#import <SVProgressHUD.h>

@interface RatingViewController ()<EDStarRatingProtocol, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBGImageView;
@property (strong, nonatomic) EDStarRating *ratingView;
@property (nonatomic) int sessionCost;

@end

@implementation RatingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self configRatingView];
	[self populateWithMockData];
}


- (void)populateWithMockData
{
	int minutes = arc4random() % 5 + 2;
	self.sessionCost = minutes * 4;
	self.minutesLabel.text = [NSString stringWithFormat:@"%i minutes session",minutes];
	self.amountLabel.text = [NSString stringWithFormat:@"$%i",self.sessionCost];
	self.personNameLabel.text = @"Courtney";
	
	self.personPhotoImageView.image = [UIImage imageNamed:@"mockFaces-female1.jpg"];
	self.personPhotoImageView.layer.borderWidth = 1.0;
	self.personPhotoImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.personPhotoImageView.layer.cornerRadius = self.personPhotoImageView.frame.size.width/2;
	self.personPhotoImageView.layer.masksToBounds = YES;
}

- (void)configRatingView
{
	self.view.backgroundColor = [AVHexColor colorWithHexString:@"f2f3f4"];
	self.bottomBGImageView.backgroundColor = [AVHexColor colorWithHexString:@"cbcbcb"];
	
	CGSize ratingViewSize = CGSizeMake(250, 60);
	self.ratingView = [[EDStarRating alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - ratingViewSize.width/2, 500, ratingViewSize.width, ratingViewSize.height)];
//	self.ratingView.backgroundColor = [UIColor lightGrayColor];
	self.ratingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	self.ratingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	self.ratingView.maxRating = 5.0;
	self.ratingView.delegate = self;
	self.ratingView.horizontalMargin = 10.0;
	self.ratingView.editable = YES;
	self.ratingView.displayMode = EDStarRatingDisplayFull;
	[self.ratingView  setNeedsDisplay];
	self.ratingView.tintColor = [AVHexColor colorWithHexString:@"ffc600"];
	
	self.ratingView.rating= 0;
	[self starsSelectionChanged:self.ratingView rating:self.ratingView.rating];
	[self.view addSubview:self.ratingView];
	
	self.feedbackTextView.backgroundColor = [AVHexColor colorWithHexString:@"cecece"];
	self.feedbackTextView.layer.cornerRadius = 4.0;
	self.feedbackTextView.layer.masksToBounds = YES;
	self.feedbackTextView.delegate = self;
	self.feedbackTextView.tintColor = [UIColor darkGrayColor];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
	static NSString *placeholder = @"Tell us your feedback...";
	if([textView.text isEqualToString:placeholder])
		textView.text = @"";
	
	textView.textAlignment = NSTextAlignmentLeft;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
	static NSString *placeholder = @"Tell us your feedback...";
	if(textView.text.length < 1){
		textView.text = placeholder;
		textView.textAlignment = NSTextAlignmentCenter;
	}
}

- (IBAction)doneButtonTapped:(id)sender
{
	if(self.ratingView.rating < 1.0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rating required" message:@"Please rate your last session" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alert show];
	}
	else{
		[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
		
		static NSString *placeholder = @"Tell us your feedback...";
		
		PFObject *feedbackObj = [PFObject objectWithClassName:@"Requests"];
		feedbackObj[@"customer"] = @"Rajat";
		feedbackObj[@"stylist"] = @"Courtney";
		feedbackObj[@"status"] = @"test_finished";
		int ratingOn100Scale = self.ratingView.rating*20.0;
		feedbackObj[@"stylist_rating"] = [NSNumber numberWithInt:ratingOn100Scale];
		
		if(self.feedbackTextView.text.length && ![self.feedbackTextView.text isEqualToString:placeholder])
		{
			feedbackObj[@"customer_feedback"] = self.feedbackTextView.text;
		}
		feedbackObj[@"charges"] = [NSNumber numberWithInteger:self.sessionCost];
		
		[feedbackObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[SVProgressHUD dismiss];
			
			if(succeeded)
			{
				[self dismissViewControllerAnimated:YES completion:nil];
			}
			else
			{
				[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Coulnd't save feedback. Please tap Done again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
				NSLog(@"feedback save error: %@", error);
			}
		}];
	}
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
//	NSLog(@"set and get: %.2f", rating);
}



@end
