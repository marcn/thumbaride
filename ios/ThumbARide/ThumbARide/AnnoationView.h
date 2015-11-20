//
//  PickupAnnoationView.h
//  ThumbARide
//
//  Created by Alex Chugunov on 11/19/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, AnnotationMode) {
    AnnotationModeNone,
    AnnotationModePasenger,
    AnnotationModeDriver,
};

@interface AnnoationView : MKAnnotationView

@property (nonatomic) AnnotationMode mode;
@property (nonatomic) BOOL tapped;

+ (instancetype)viewWithAnnotation:(id<MKAnnotation>)annotation mode:(AnnotationMode)mode onMapView:(MKMapView *)mapView;

@end
