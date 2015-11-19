//
//  RideViewController.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "RideViewController.h"
#import "RideViewModel.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import GoogleMaps;

static NSString * const kGoogleMapsAPIKey = @"AIzaSyBGiI5rT3mXPgdgYy29IEfAg01lPx089NI";

@interface RideViewController () <RideViewModelDelegate, FBSDKLoginButtonDelegate>

@property (nonatomic, strong) RideViewModel *viewModel;
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) UITextField *pickup;
@property (nonatomic, strong) UITextField *destination;
@property (nonatomic, strong) UISwitch *mode;
@property (nonatomic, strong) FBSDKLoginButton *logoutButton;

@end

@implementation RideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [GMSServices provideAPIKey:kGoogleMapsAPIKey];
    
    self.viewModel = [RideViewModel new];
    self.viewModel.delegate = self;
    
    
    self.view.backgroundColor = [UIColor lightTextColor];
    
    // Position the camera at 0,0 and zoom level 1.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0
                                                            longitude:0.0
                                                                 zoom:10];
    
    GMSMarker *marker = [GMSMarker new];
    marker.snippet = @"Me";
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.selectedMarker = marker;
    
    self.pickup = [UITextField new];
    self.destination = [UITextField new];
    self.mode = [UISwitch new];
    self.logoutButton = [[FBSDKLoginButton alloc] init];
    
    self.pickup.translatesAutoresizingMaskIntoConstraints = NO;
    self.destination.translatesAutoresizingMaskIntoConstraints = NO;
    self.mode.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.pickup.placeholder = @"Pick up address";
    self.destination.placeholder = @"Destionation address";
    self.logoutButton.delegate = self;
    
    [self.view addSubview:self.pickup];
    [self.view addSubview:self.destination];
    [self.view addSubview:self.mode];
    [self.view addSubview:self.logoutButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pickup]-[_destination]-[_mode]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_pickup, _destination, _mode, _logoutButton)]];
    
    for (UIView *subview in self.view.subviews) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview(50)]-(50)-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(subview)]];
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_logoutButton(40)]-(10)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_logoutButton)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self presentViewController:[LoginViewController new] animated:YES completion:nil];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
}


- (void)fetchNearby {
    //    [self.viewModel fetchDataWithParams:@{
    //                                          @"mode" : self.mode,
    //                                          @"zoomlevel" : @(self.mapView.zoomLevel)}
    //     ];
}

# pragma mark - ride view model

- (void)rideViewModel:(RideViewModel *)model didFinishLoading:(NSDictionary *)data {
    
    // data will contain a list of lag/long and drivers/passengers metadata
    
    // populate car or thumb icons based on the result data
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
