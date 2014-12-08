//
//  ProfileViewController.m
//  Fashin-SP14
//
//  Created by Rajat on 12/8/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


@end
