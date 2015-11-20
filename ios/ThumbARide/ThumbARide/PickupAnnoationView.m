//
//  PickupAnnoationView.m
//  ThumbARide
//
//  Created by Alex Chugunov on 11/19/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "PickupAnnoationView.h"

@implementation PickupAnnoationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.draggable = YES;
        self.image = [UIImage imageNamed:@"icon-start"];
    }
    return self;
}

@end
