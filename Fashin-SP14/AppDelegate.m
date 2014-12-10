//
//  AppDelegate.m
//  Fashin-SP14
//
//  Created by Rajat on 10/2/14.
//  Copyright (c) 2014 rajatkumar. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	//Init Parse
	[Parse setApplicationId:@"Parse_App_ID"
				  clientKey:@"Parse_App_Key"];
	//Init Parse Analytics
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[PFFacebookUtils initializeFacebook];
	
	//register push token
	UIUserNotificationSettings *settings =
	[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
	 UIUserNotificationTypeBadge |
	 UIUserNotificationTypeSound
									  categories:nil];
	[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
	[[UIApplication sharedApplication] registerForRemoteNotifications];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

	//From Parse FB Docs
	[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//From Facebook Docs
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
	// attempt to extract a token from the url
	return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	//NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken %@", deviceToken);
	// Store the deviceToken in the current Installation and save it to Parse.
	PFInstallation *currentInstallation = [PFInstallation currentInstallation];
	[currentInstallation setDeviceTokenFromData:deviceToken];
	if([PFUser currentUser])
		[currentInstallation setObject:[PFUser currentUser] forKey:@"userObject"];
	[currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !(TARGET_IPHONE_SIMULATOR)
	NSLog(@"Push token reg failed: %@", error);
#endif
}

@end
