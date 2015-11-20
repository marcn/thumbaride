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
#import "AnnoationView.h"
#import "ProfileViewController.h"

//static NSString * const kGoogleMapsAPIKey = @"AIzaSyBGiI5rT3mXPgdgYy29IEfAg01lPx089NI";

@interface RideViewController () <RideViewModelDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) RideViewModel *viewModel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPinAnnotationView *apin;
@property (nonatomic, strong) UIImageView *pin;
@property (nonatomic, strong) UIImageView *pickupIcon;
//@property (nonatomic, strong) GMSMapView *gmapView;
@property (nonatomic, strong) UIButton *pickup;
@property (nonatomic, strong) UIButton *destination;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *thumbButton;
@property (nonatomic, strong) UIButton *driveButton;
@property (nonatomic) CLLocationCoordinate2D updatedCoord;
@property (nonatomic) BOOL shouldShowCurrentLocation;
@property (nonatomic, strong) UIView *controlPanel;
@property (nonatomic, strong) UIView *directionView;
@property (nonatomic) BOOL isReverseDirection;
@property (nonatomic) AnnotationMode mode;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) FBSDKLoginButton *logoutButton;
@property (nonatomic, strong) MKDirections *directions;
@property (nonatomic, strong) MKRoute *currentRoute;
@property (nonatomic, strong) MKPointAnnotation *currentUser;
@end

@implementation RideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [GMSServices provideAPIKey:kGoogleMapsAPIKey];
    
    srand48(time(0));
    
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
    
    self.pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-start"]];
    self.pin.center = self.view.center;
    [self.mapView addSubview:self.pin];
    
    self.controlPanel = [UIView new];
    
    self.pickupIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-start"]];
    self.pickup = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pickup.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.pickup.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.pickup.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.destination = [UIButton buttonWithType:UIButtonTypeCustom];
    self.destination.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.destination.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.destination.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton setImage:[UIImage imageNamed:@"icon-menu"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *orangeColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.0 alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    self.thumbButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.thumbButton setBackgroundColor:orangeColor];
    [self.thumbButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.thumbButton setTitleColor:textColor forState:UIControlStateSelected];
    self.thumbButton.tintColor = orangeColor;
    self.thumbButton.layer.cornerRadius = 5;
    self.thumbButton.clipsToBounds = YES;
    
    UIColor *blueColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:1];
    self.driveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.driveButton.layer.cornerRadius = 5;
    self.driveButton.clipsToBounds = YES;
    [self.driveButton setBackgroundColor:blueColor];
    [self.driveButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.driveButton setTitleColor:textColor forState:UIControlStateSelected];
    self.driveButton.tintColor = blueColor;
    
    self.pickup.translatesAutoresizingMaskIntoConstraints = NO;
    self.destination.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.thumbButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.driveButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.pickup setTitle:@"Current Location" forState:UIControlStateNormal];
    [self.destination setTitle:@"Pandora" forState:UIControlStateNormal];
    
    UIView *arrow = [UIView new];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(15, 15)];
    [path addLineToPoint:CGPointMake(0, 30)];
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    [arrow.layer addSublayer:shapeLayer];
    self.directionView = arrow;
    self.directionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.thumbButton setTitle:@"Thumb a ride" forState:UIControlStateNormal];
    [self.thumbButton setTitle:@"Call driver" forState:UIControlStateSelected];
    [self.driveButton setTitle:@"Enter driver mode" forState:UIControlStateNormal];
    [self.driveButton setTitle:@"Call passenger" forState:UIControlStateSelected];
    
    self.controlPanel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self.controlPanel addSubview:self.pickupIcon];
    self.pickupIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.progressView = [UIProgressView new];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    UIColor *green = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    self.progressView.tintColor = green;
    
    [self.controlPanel addSubview:self.pickup];
    [self.controlPanel addSubview:self.directionView];
    [self.controlPanel addSubview:self.destination];
    [self.controlPanel addSubview:self.menuButton];
    
    [self.view addSubview:self.controlPanel];
    self.controlPanel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_controlPanel]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_controlPanel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_controlPanel(200)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_controlPanel)]];
    
    [self.controlPanel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickupIcon(30)]-[_pickup][_directionView(30)][_destination(80)]-(15)-[_menuButton(30)]-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_pickupIcon, _pickup, _directionView, _destination, _menuButton)]];
    
    for (UIView *subview in self.controlPanel.subviews) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[subview(30)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(subview)]];
    }
    
    [self.controlPanel addSubview:self.progressView];
    
    [self.controlPanel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_progressView]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_progressView)]];
    [self.controlPanel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_progressView(10)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_progressView)]];
    
    [self.controlPanel addSubview:self.thumbButton];
    [self.controlPanel addSubview:self.driveButton];
    [self.controlPanel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_thumbButton(50)]-(15)-[_driveButton(50)]-(20)-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_thumbButton, _driveButton)]];
    [self.controlPanel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_thumbButton]-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_thumbButton)]];
    [self.controlPanel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_driveButton]-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(_driveButton)]];
    
    
    [self.controlPanel addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbButton
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.controlPanel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0]];
    [self.controlPanel addConstraint:[NSLayoutConstraint constraintWithItem:self.driveButton
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.controlPanel
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
    
    
    [self.thumbButton addTarget:self action:@selector(thumbARide:) forControlEvents:UIControlEventTouchUpInside];
    [self.driveButton addTarget:self action:@selector(drive:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)setIsReverseDirection:(BOOL)isReverseDirection {
    
    if (_isReverseDirection == isReverseDirection)
        return;
    
    _isReverseDirection = isReverseDirection;
    
    [self.directionView.layer.sublayers.firstObject removeFromSuperlayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (isReverseDirection) {
        [path moveToPoint:CGPointMake(15, 0)];
        [path addLineToPoint:CGPointMake(0, 15)];
        [path addLineToPoint:CGPointMake(15, 30)];

    } else {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(15, 15)];
        [path addLineToPoint:CGPointMake(0, 30)];
    }
    
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.directionView.layer addSublayer:shapeLayer];
}


- (void)call {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.mode == AnnotationModeDriver ? @"telprompt://1-415-782-3415" : @"telprompt://1-415-942-8927"]];
}

- (void)menuClicked:(UIButton *)button {
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[ProfileViewController new]];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)showAlert:(NSNumber *)alertMode {
    
    switch ([alertMode integerValue]) {
        case 0: {
            NSString *title = @"";
            NSString *msg = @"";
            if (self.mode == AnnotationModeDriver) {
                title = @"You've notified the passengers";
                msg = @"Now go pick them up!";
            } else if (self.mode == AnnotationModePasenger) {
                title = @"Be ready outside";
                msg = [NSString stringWithFormat:@"Your driver will arrive in %@ min", @1]; //@(round([self.currentRoute expectedTravelTime] / 60.0))];
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Confirm"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self didConfirm];
                                                    }]];
            [self showViewController:alert sender:self];
        }
            break;
            
            
        case 1: {
            
            NSString *title = @"";
            NSString *msg = @"";
            if (self.mode == AnnotationModeDriver) {
                title = @"You have arrived";
                msg = @"You can leave in 1 min";
            } else if (self.mode == AnnotationModePasenger) {
                title = @"Your driver has arrived";
                msg = @"Leaving in 1 min";
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your driver has arrived"
                                                                           message:@"Leaving in 1 min"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                    }]];
            [self showViewController:alert sender:self];
        }
            break;
            
        default:
            break;
    }
}

- (void)didConfirm {
    
    if (self.mode == AnnotationModeDriver) {
        self.driveButton.selected = YES;
    } else if (self.mode == AnnotationModePasenger) {
        self.thumbButton.selected = YES;
    }
    
    self.pin.image = [UIImage imageNamed:@"icon-end"];
    self.progressView.progress = 0;
    
    if (self.mode == AnnotationModeDriver)
        return;
    
    NSUInteger pointCount = self.currentRoute.polyline.pointCount;
    CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
    [self.currentRoute.polyline getCoordinates:routeCoordinates
                             range:NSMakeRange(0, pointCount)];
    
    NSTimeInterval stepDuration = 40 / pointCount;

    [self executeRoute:routeCoordinates duration:stepDuration currentPoint:0 pointsCount:pointCount];
    
    free(routeCoordinates);
    return;
}

- (void)executeRoute:(CLLocationCoordinate2D *)coordinates duration:(NSTimeInterval)duration currentPoint:(NSInteger)currentPoint pointsCount:(NSInteger)pointsCount {
    if (currentPoint < pointsCount) {
        [UIView animateWithDuration:duration animations:^{
            self.currentUser.coordinate = coordinates[currentPoint];
        } completion:^(BOOL finished) {
            if (finished) {
                [self executeRoute:coordinates duration:duration currentPoint:currentPoint + 1 pointsCount:pointsCount];
            }
        }];
    }
    else {
        [self showAlert:@1];
    }
}
              

- (void)setMode:(AnnotationMode)mode {
    
    if (_mode == mode)
        return;
    
    _mode = mode;
    
    self.isReverseDirection = (mode == AnnotationModeDriver);

    self.pin.image = [UIImage imageNamed:@"icon-start"];

    if (mode == AnnotationModeDriver) {
        self.thumbButton.selected = NO;
    } else if (mode == AnnotationModePasenger) {
        self.driveButton.selected = NO;
        [self.driveButton setTitle:@"Enter driver mode" forState:UIControlStateNormal];
    } else {
        self.thumbButton.selected = NO;
        self.driveButton.selected = NO;
        [self.driveButton setTitle:@"Enter driver mode" forState:UIControlStateNormal];
    }

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self updateCoord:nil];
    [self updateNearbyEntites];
}

- (void)thumbARide:(UIButton *)button {
    
    self.mode = AnnotationModePasenger;
    
    if (button.selected) {
        [self call];
        return;
    }
    
    [self notifyEntities];
}

- (void)drive:(UIButton *)button {
    
    // show thumbs
    self.mode = AnnotationModeDriver;
    
    if (button.selected) {
        [self call];
        return;
    }
    
    if (button.tag == -1) {
        [self notifyEntities];
        button.tag = 0;
    }
}


- (void)notifyEntities {
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         while (self.progressView.progress < 1) {
                             CGFloat stepSize = 0.1f;
                             [self.progressView setProgress:self.progressView.progress+stepSize animated:YES];
                         }
                     } completion:^(BOOL finished) {
                         // as a passenger, pick a car and update car location
                         if (self.mapView.annotations.count <= 1)
                             return;
                         
                         MKPointAnnotation *annotation = nil;
                         for (id<MKAnnotation> annot in self.mapView.annotations) {
                             if (![annot isKindOfClass:[MKUserLocation class]]) {
                                 annotation = annot;
                                 break;
                             }
                         }
                         
                         [self updateCoord:nil];

                         MKPlacemark *destinationMark = [[MKPlacemark alloc] initWithCoordinate:self.updatedCoord addressDictionary:nil];
                         MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationMark];
                         
                         MKPlacemark *sourceMark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:nil];
                         MKMapItem *sourceItem = [[MKMapItem alloc] initWithPlacemark:sourceMark];
                         
                         MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
                         [request setSource:sourceItem];
                         [request setDestination:destinationItem];
                         
                         self.directions = [[MKDirections alloc] initWithRequest:request];
                         [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
                             self.directions = nil;
                             self.currentRoute = [response.routes firstObject];
                             self.currentUser = annotation;
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 [self showAlert:@0];
                             });
                         }];
                     }];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.viewModel requestLocationAuthorization];
    } else {
        if (self.shouldShowCurrentLocation) { /// @todo: use flag here?
            [self.viewModel refreshLocation];
            
            [self rideViewModel:self willCenterOnCurrentLocation:self.viewModel.locationCoord];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)tap:(UIGestureRecognizer *)g {
    
}

- (void)fetchNearby {
    //    [self.viewModel fetchDataWithParams:@{
    //                                          @"mode" : self.mode,
    //                                          @"zoomlevel" : @(self.mapView.zoomLevel)}
    //     ];
}

# pragma mark - ride view model

- (CLLocationCoordinate2D)randCoord {
    double rx = drand48();
    double ry = drand48();
    double tx = drand48();
    double ty = drand48();
    
    double x = (rx * 2 - 1) * 0.005;
    x *= (tx >= rx) ? 1 : -1;
    double y = (ry * 2 - 1) * 0.005;
    y *= (ty >= rx) ? -1 : 1;
    NSLog(@"rx: %f, ry: %f, tx: %f, ty: %f, x: %f, y: %f", rx, ry, tx, ty, x, y);
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.updatedCoord.latitude + x, self.updatedCoord.longitude + y);
    return coordinate;
}

- (void)rideViewModel:(RideViewModel *)model didUpdateAddress:(NSString *)address {
    
    [self.pickup setTitle:address forState:UIControlStateNormal];
    
    if (self.updatedCoord.latitude == 0 && self.updatedCoord.longitude == 0) {
        return;
    }
    
    [self updateCoord:nil];
    [self updateNearbyEntites];
}

- (void)updateNearbyEntites {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=1; self.mapView.annotations.count < 6; i++) {
            [self.mapView addAnnotation:[MKPointAnnotation new]];
        }
        
        for (MKPointAnnotation *annotation in self.mapView.annotations) {
            CLLocationCoordinate2D coordinate = [self randCoord];
            NSLog(@"xx: %f, yy: %f", coordinate.latitude, coordinate.longitude);
            annotation.coordinate = coordinate;
        }
    });
}

- (void)rideViewModel:(RideViewModel *)model willCenterOnCurrentLocation:(CLLocationCoordinate2D)coord {
    [self.mapView setCenterCoordinate:coord zoomLevel:15 animated:YES];
    
    self.mode = AnnotationModePasenger;
    self.shouldShowCurrentLocation = NO;
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
    AnnoationView *view = [AnnoationView viewWithAnnotation:annotation
                                                       mode:self.mode
                                                  onMapView:self.mapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnAnnotation:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tappedOnAnnotation:(UIGestureRecognizer *)g {
    
    AnnoationView *view = (AnnoationView *)g.view;
    view.tapped = !view.tapped;
    
    if (view.tapped && self.mode == AnnotationModeDriver) {
        self.driveButton.tag = -1;
        [self.driveButton setTitle:@"Give a ride" forState:UIControlStateNormal];
    }
    
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
            
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                [self updateCoord:recognizer];
            }
            return YES;
        }
    }
    
    return NO;
}

- (void)updateCoord:(UIGestureRecognizer *)recognizer {
    // convert touched position to map coordinate
    CGPoint userTouch = recognizer ? [recognizer locationInView:self.mapView] : self.view.center;
    self.updatedCoord = [self.mapView convertPoint:userTouch toCoordinateFromView:self.mapView];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    mapChangedFromUserInteraction = [self mapViewRegionDidChangeFromUserInteraction];
    
    NSLog(@"Updated coord %@:%@", @(self.updatedCoord.latitude), @(self.updatedCoord.longitude));
    
    [self.viewModel updateAddressWithCoord:self.updatedCoord];
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self presentViewController:[LoginViewController new] animated:YES completion:nil];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
}



@end
