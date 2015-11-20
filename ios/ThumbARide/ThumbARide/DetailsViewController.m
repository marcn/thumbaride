//
//  DetailsViewController.m
//  ThumbARide
//
//  Created by Alex Chugunov on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "DetailsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface DetailsViewController ()

@property (nonatomic, strong) NSDictionary *user;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationLabel;
@property (nonatomic, weak) IBOutlet MKMapView *destinationMapView;

- (IBAction)pickUp:(id)sender;

@end

@implementation DetailsViewController

- (instancetype)initWithUser:(NSDictionary *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Jane Doe";
//    MKPointAnnotation *annotation = self.mapView.annotations.firstObject;
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)
//    [annotation setCoordinate:coord];
//    [self.mapView setCenterCoordinate:coord zoomLevel:15 animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(cancel)];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(detailsViewControllerDidCancel:)]) {
            [self.delegate detailsViewControllerDidCancel:self];
        }
    }];
}

- (IBAction)pickUp:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(detailsViewControllerDidPickUp:)]) {
            [self.delegate detailsViewControllerDidPickUp:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
