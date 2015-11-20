//
//  PickupAnnoationView.m
//  ThumbARide
//
//  Created by Alex Chugunov on 11/19/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "AnnoationView.h"

@implementation AnnoationView

+ (instancetype)viewWithAnnotation:(id<MKAnnotation>)annotation mode:(AnnotationMode)mode onMapView:(MKMapView *)mapView {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString *reuseIdentifier = @"";
    
    switch (mode) {
        case AnnotationModeDriver:
            reuseIdentifier = @"driverId";
            break;
        case AnnotationModePasenger:
            reuseIdentifier = @"passengerId";
        default:
            break;
    }

    AnnoationView *view = (AnnoationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];

    if (!view) {
        view = [[AnnoationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    }
    
    view.mode = mode;
    
    return view;
}

- (void)setMode:(AnnotationMode)mode {
 
    _mode = mode;
    
    NSString *iconString = @"";
    switch (mode) {
        case AnnotationModeDriver:
            iconString = self.selected ? @"icon-thumb-ride" : @"icon-thumb-noride";
            break;
        case AnnotationModePasenger:
            iconString = @"icon-car";
        default:
            break;
    }
    self.image = [UIImage imageNamed:iconString];
}

- (void)setTapped:(BOOL)tapped {

    _tapped = tapped;
    
    NSString *iconString = @"";
    
    switch (self.mode) {
        case AnnotationModeDriver:
            iconString = tapped ? @"icon-thumb-ride" : @"icon-thumb-noride";
            break;
        case AnnotationModePasenger:
            iconString = @"icon-car";
        default:
            break;
    }
    self.image = [UIImage imageNamed:iconString];
    
}

@end
