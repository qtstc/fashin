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

@interface RatingViewController ()<EDStarRatingProtocol>

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self configRatingView];
}

- (void)configRatingView
{
	CGSize ratingViewSize = CGSizeMake(250, 60);
	EDStarRating *ratingView = [[EDStarRating alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - ratingViewSize.width/2, self.view.frame.size.height*3/4, ratingViewSize.width, ratingViewSize.height)];
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
	
	ratingView.rating= 5;
	[self starsSelectionChanged:ratingView rating:5];
	[self.view addSubview:ratingView];
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
