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

@end


@interface RideViewModel : NSObject <CLLocationManagerDelegate, RideViewModelDelegate>

@property (nonatomic) id<RideViewModelDelegate> delegate;
- (void)fetchDataWithParams:(NSDictionary *)params;

@end


