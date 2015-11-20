//
//  ViewController.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RideViewController.h"

@interface LoginViewController () <FBSDKLoginButtonDelegate>

@end

@implementation LoginViewController

- (void)loadMapView {
    [self presentViewController:[RideViewController new] animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *splashImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash-6plus"]];
    splashImage.contentMode = UIViewContentModeScaleAspectFill;
    splashImage.frame = self.view.bounds;
    splashImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:splashImage];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.center = CGPointMake(self.view.center.x, self.view.center.y + 75);
    [self.view addSubview:loginButton];
    
    loginButton.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        loginButton.alpha = 1;
    }];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil && result.token != nil) {
        [self loadMapView];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"Log out");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
