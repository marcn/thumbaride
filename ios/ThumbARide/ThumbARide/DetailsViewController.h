//
//  DetailsViewController.h
//  ThumbARide
//
//  Created by Alex Chugunov on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol DetailsViewControllerDelegate;

@interface DetailsViewController : UIViewController

@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
- (instancetype)initWithUser:(NSDictionary *)user;

@end

@protocol DetailsViewControllerDelegate <NSObject>

- (void)detailsViewControllerDidCancel:(DetailsViewController *)controller;
- (void)detailsViewControllerDidPickUp:(DetailsViewController *)controller;

@end
