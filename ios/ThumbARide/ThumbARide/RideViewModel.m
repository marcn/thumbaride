//
//  RideModel.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "RideViewModel.h"

@interface RideViewModel ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation RideViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }

    return self;
}

- (void)fetchDataWithParams:(NSDictionary *)params {
    
    // get the following from params
//    driver/passenger mode,
//    user zoomLevel

    // get the following from locationManager
//    self.locationManager.location.coordinate.latitude,
//    self.locationManager.location.coordinate.longitude,
    
    // then make a request

}


- (void)requestLocationAuthorization {
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)refreshLocation {
    [self.locationManager startUpdatingLocation];
}

- (CLLocationCoordinate2D)locationCoord {
    return self.locationManager.location.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *loc = locations.firstObject;
    [self.delegate rideViewModel:self didUpdateLocation:loc.coordinate];
}


@end
