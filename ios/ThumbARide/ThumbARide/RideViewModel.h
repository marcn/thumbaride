//
//  RideModel.h
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;


@class RideViewModel;
@protocol RideViewModelDelegate <NSObject>

- (void)rideViewModel:(RideViewModel *)model didFinishLoading:(NSDictionary *)data;
- (void)rideViewModel:(RideViewModel *)model didUpdateLocation:(CLLocationCoordinate2D)coord;

@end


@interface RideViewModel : NSObject <CLLocationManagerDelegate>

@property (nonatomic) id<RideViewModelDelegate> delegate;
@property (nonatomic) CLLocationCoordinate2D locationCoord;

- (void)fetchDataWithParams:(NSDictionary *)params;
- (void)requestLocationAuthorization;
- (void)refreshLocation;

@end


