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
@property (nonatomic) BOOL shouldCenterOnCurrentLocation;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation RideViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        _geocoder = [CLGeocoder new];
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
        self.shouldCenterOnCurrentLocation = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (self.shouldCenterOnCurrentLocation) {
        
        CLLocation *loc = locations.firstObject;
        [self.delegate rideViewModel:self willCenterOnCurrentLocation:loc.coordinate];
        self.shouldCenterOnCurrentLocation = NO;
    }
}

- (void)updateAddressWithCoord:(CLLocationCoordinate2D)coord
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSString *address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                              placemark.subThoroughfare, placemark.thoroughfare,
                              placemark.postalCode, placemark.locality,
                              placemark.administrativeArea,
                              placemark.country];
        
        if ([address rangeOfString:@"null"].length == 0) {
            [self.delegate rideViewModel:self didUpdateAddress:address];
        }
            
    }];
}


@end
