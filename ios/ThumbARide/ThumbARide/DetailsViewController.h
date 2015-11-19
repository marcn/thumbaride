//
//  DetailsViewController.h
//  ThumbARide
//
//  Created by Alex Chugunov on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *user;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationLabel;
//@property (nonatomic, weak) IBOutlet *destinationMapView;

@end
