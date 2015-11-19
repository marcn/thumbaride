//
//  AppDelegate.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RideViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import GoogleMaps;

static NSString * const kGoogleMapsAPIKey = @"AIzaSyBGiI5rT3mXPgdgYy29IEfAg01lPx089NI";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if ([FBSDKAccessToken currentAccessToken] != nil) {
        self.window.rootViewController = [RideViewController new];
    } else {
        self.window.rootViewController = [LoginViewController new];
    }
    
    [GMSServices provideAPIKey:kGoogleMapsAPIKey];

    // add google key
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
