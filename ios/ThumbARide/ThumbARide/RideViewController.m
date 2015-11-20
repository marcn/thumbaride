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
#import "DestinationAnnotationView.h"
#import "PickupAnnoationView.h"
#import "RiderAnnotationView.h"
#import "DriverAnnotationView.h"

//static NSString * const kGoogleMapsAPIKey = @"AIzaSyBGiI5rT3mXPgdgYy29IEfAg01lPx089NI";

@interface RideViewController () <RideViewModelDelegate, MKMapViewDelegate, FBSDKLoginButtonDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) RideViewModel *viewModel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPinAnnotationView *apin;
@property (nonatomic, strong) UIImageView *pin;
//@property (nonatomic, strong) GMSMapView *gmapView;
@property (nonatomic, strong) UITextField *pickup;
@property (nonatomic, strong) UITextField *destination;
@property (nonatomic, strong) UISwitch *mode;
@property (nonatomic) BOOL shouldShowCurrentLocation;
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
    self.mapView.delegate = self;    
    self.shouldShowCurrentLocation = YES;
    
    self.mapView.delegate = self;

    self.pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-start-32"]];
    self.pin.center = self.view.center;
    [self.mapView addSubview:self.pin];
    
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    tap.delegate = self;
    pan.delegate = self;
    swipe.delegate = self;
    pinch.delegate = self;
    [self.view addGestureRecognizer:pan];
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:pinch];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.viewModel requestLocationAuthorization];
    } else {
        if (self.shouldShowCurrentLocation) {
            [self.viewModel refreshLocation];
            [self.mapView setCenterCoordinate:self.viewModel.locationCoord zoomLevel:15 animated:YES];
            self.shouldShowCurrentLocation = NO;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)tap:(UIGestureRecognizer *)g {
    
    if (self.pickup.isFirstResponder) {
        [self.pickup resignFirstResponder];
    }
    
    if (self.destination.isFirstResponder) {
        [self.destination resignFirstResponder];
    }
    
}

- (void)pan:(UIGestureRecognizer *)g {
    
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

- (void)rideViewModel:(RideViewModel *)model willCenterOnCurrentLocation:(CLLocationCoordinate2D)coord {
    [self.mapView setCenterCoordinate:self.viewModel.locationCoord zoomLevel:15 animated:YES];
}

- (void)rideViewModel:(RideViewModel *)model didFinishLoading:(NSDictionary *)data {
    
    // data will contain a list of lag/long and drivers/passengers metadata
    
    // populate car or thumb icons based on the result data
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *pickupIdentifier = @"Pickup";
    PickupAnnoationView *view = (PickupAnnoationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pickupIdentifier];
    if (!view) {
        view = [[PickupAnnoationView alloc] initWithAnnotation:annotation reuseIdentifier:pickupIdentifier];
    }
    return view;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState  {
 
    
    
}

static BOOL mapChangedFromUserInteraction = NO;

- (BOOL)mapViewRegionDidChangeFromUserInteraction
{
    UIView *view = self.mapView.subviews.firstObject;
    //  Look through gesture recognizers to determine whether this region change is from user interaction
    for(UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateEnded) {
            return YES;
        }
    }
    
    return NO;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    mapChangedFromUserInteraction = [self mapViewRegionDidChangeFromUserInteraction];
    
    if (mapChangedFromUserInteraction) {
        // user changed map region
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    PickupAnnoationView *view = [mapView viewForAnnotation:self.mapView.annotations.firstObject];
    view.dragState = MKAnnotationViewDragStateEnding;
    NSLog(@"%@:%@", @([view.annotation coordinate].latitude), @([view.annotation coordinate].longitude));
    if (mapChangedFromUserInteraction) {
        
        // user changed map region
    }
}
@end
