//
//  DriverAnnotationView.m
//  ThumbARide
//
//  Created by Alex Chugunov on 11/19/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "DriverAnnotationView.h"

@implementation DriverAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"icon-thumb-noride"];
    }
    return self;
}

@end
