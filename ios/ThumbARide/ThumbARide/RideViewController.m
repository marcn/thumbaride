//
//  RideViewController.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

@import MapKit;

#import "RideViewController.h"
#import "RideViewModel.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MKMapView+ZoomLevel.h"

//static NSString * const kGoogleMapsAPIKey = @"AIzaSyBGiI5rT3mXPgdgYy29IEfAg01lPx089NI";

@interface RideViewController () <RideViewModelDelegate, MKMapViewDelegate, FBSDKLoginButtonDelegate>

@property (nonatomic, strong) RideViewModel *viewModel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPinAnnotationView *pin;
//@property (nonatomic, strong) GMSMapView *gmapView;
@property (nonatomic, strong) UITextField *pickup;
@property (nonatomic, strong) UITextField *destination;
@property (nonatomic, strong) UISwitch *mode;
@property (nonatomic, strong) FBSDKLoginButton *logoutButton;

@end

@implementation RideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [GMSServices provideAPIKey:kGoogleMapsAPIKey];
    
    self.viewModel = [RideViewModel new];
    self.viewModel.delegate = self;
    
    self.view.backgroundColor = [UIColor lightTextColor];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.showsCompass = NO;
    self.mapView.showsUserLocation = YES;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"Me";
    [self.mapView addAnnotation:annotation];
    self.mapView.delegate = self;
    
    self.pickup = [UITextField new];
    self.destination = [UITextField new];
    self.pickup.borderStyle = UITextBorderStyleRoundedRect;
    self.destination.borderStyle = UITextBorderStyleRoundedRect;
    self.mode = [UISwitch new];
    self.logoutButton = [[FBSDKLoginButton alloc] init];
    
    self.pickup.translatesAutoresizingMaskIntoConstraints = NO;
    self.destination.translatesAutoresizingMaskIntoConstraints = NO;
    self.mode.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.pickup.placeholder = @"From";
    self.destination.placeholder = @"To";
    self.logoutButton.delegate = self;
    
    self.pickup.backgroundColor = [UIColor lightGrayColor];
    self.destination.backgroundColor = [UIColor lightGrayColor];
    
    
    [self.view addSubview:self.pickup];
    [self.view addSubview:self.destination];
    [self.view addSubview:self.mode];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pickup(width)]-[_destination(width)]-[_mode]-|"
                                                                      options:0
                                                                      metrics:@{ @"width" : @(CGRectGetWidth(self.view.bounds) / 2.0 - 50) }
                                                                        views:NSDictionaryOfVariableBindings(_pickup, _destination, _mode)]];
    
    for (UIView *subview in self.view.subviews) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[subview(40)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(subview)]];
    }
    
    
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.logoutButton];
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
    
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_mapView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_mapView)]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:pinch];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.viewModel requestLocationAuthorization];
    } else {
        [self.viewModel refreshLocation];
    }
}

- (void)tap:(UIGestureRecognizer *)g {
    
    if (self.pickup.isFirstResponder) {
        [self.pickup resignFirstResponder];
    }
    
    if (self.destination.isFirstResponder) {
        [self.destination resignFirstResponder];
    }
    
}


- (void)swipe:(UIGestureRecognizer *)g {
    
}

- (void)pinch:(UIGestureRecognizer *)g {
    
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

- (void)rideViewModel:(RideViewModel *)model didUpdateLocation:(CLLocationCoordinate2D)coord {
 
    MKPointAnnotation *annotation = self.mapView.annotations.firstObject;
    [annotation setCoordinate:coord];
    [self.mapView setCenterCoordinate:coord zoomLevel:15 animated:YES];
}

- (void)rideViewModel:(RideViewModel *)model didFinishLoading:(NSDictionary *)data {
    
    // data will contain a list of lag/long and drivers/passengers metadata
    
    // populate car or thumb icons based on the result data
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    
//    MKPinAnnotationView *v = [MKPinAnnotationView alloc];
//    v.draggable = YES;
//    v.canShowCallout = YES;
//    v.animatesDrop = YES;
//
//    return v;
//}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState  {
 
    
    
}


@end
