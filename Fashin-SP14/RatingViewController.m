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

@interface RatingViewController ()<EDStarRatingProtocol, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBGImageView;

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
	int amount = minutes * 4;
	self.minutesLabel.text = [NSString stringWithFormat:@"%i minutes session",minutes];
	self.amountLabel.text = [NSString stringWithFormat:@"$%i",amount];
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
	EDStarRating *ratingView = [[EDStarRating alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - ratingViewSize.width/2, 500, ratingViewSize.width, ratingViewSize.height)];
//	ratingView.backgroundColor = [UIColor lightGrayColor];
	ratingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	ratingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	ratingView.maxRating = 5.0;
	ratingView.delegate = self;
	ratingView.horizontalMargin = 10.0;
	ratingView.editable = YES;
	ratingView.displayMode = EDStarRatingDisplayFull;
	[ratingView  setNeedsDisplay];
	ratingView.tintColor = [AVHexColor colorWithHexString:@"ffc600"];
	
	ratingView.rating= 0;
	[self starsSelectionChanged:ratingView rating:ratingView.rating];
	[self.view addSubview:ratingView];
	
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
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
//	NSLog(@"set and get: %.2f", rating);
}

@end
