//
//  AppDelegate.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = [ViewController new];
    
    return YES;
}


@end
