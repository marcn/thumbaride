//
//  ProfileViewController.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/20/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "ProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ProfileViewController ()
@property (nonatomic, strong) FBSDKLoginButton *logoutButton;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.title = @"Profile";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-profile"]];
    
    UILabel *name = [UILabel new];
    UILabel *tel = [UILabel new];
    UILabel *capacity = [UILabel new];

    UIButton *logout = [UIButton new];
    name.text = @"NAME: Angelina Jolie";
    tel.text = @"PHONE: 1-415-382-4320";
    capacity.text = @"CAPACITY: 5 seats";
    [logout setTitle:@"Log out" forState:UIControlStateNormal];
    
    self.logoutButton = [[FBSDKLoginButton alloc] init];
    UIColor *buttonCol = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:0.7];
    [logout setBackgroundColor:buttonCol];
    
    [name sizeToFit];
    [tel sizeToFit];
    [capacity sizeToFit];
    [logout sizeToFit];
    
    [self.view addSubview:imageView];
    [self.view addSubview:name];
    [self.view addSubview:tel];
    [self.view addSubview:capacity];
    [self.view addSubview:logout];
    
    for (UIView *subview in self.view.subviews) {
        
        subview.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview(280)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(subview)]];
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[imageView(200)]-(50)-[name(50)]-[tel(50)]-[capacity(50)]-(>=1)-[logout(40)]-(20)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(imageView, name, tel, capacity, logout)]];
    
    
}


- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
