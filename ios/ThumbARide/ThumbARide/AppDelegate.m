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

#define FORCE_SHOW_MAP 0

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

#if FORCE_SHOW_MAP
    self.window.rootViewController = [RideViewController new];
#else
    
    if ([FBSDKAccessToken currentAccessToken] != nil) {
        self.window.rootViewController = [RideViewController new];
    } else {
        self.window.rootViewController = [LoginViewController new];
    }
#endif
    
    [self.window makeKeyAndVisible];

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
