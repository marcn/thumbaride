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
        // this will prompt user to allow location
        [_locationManager startUpdatingLocation];
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

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
}


@end
