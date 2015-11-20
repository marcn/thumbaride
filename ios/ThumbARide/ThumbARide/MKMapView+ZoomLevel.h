//
//  MKMapView+ZoomLevel.h
//  ThumbARide
//
//  Created by Ellie Shin on 11/19/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface MKMapView (ZoomLevel)

@property (assign, nonatomic) NSUInteger zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
