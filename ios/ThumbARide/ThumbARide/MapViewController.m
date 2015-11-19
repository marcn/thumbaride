//
//  MapViewController.m
//  ThumbARide
//
//  Created by Ellie Shin on 11/18/15.
//  Copyright © 2015 Pandora. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic, strong) UIView *mapView;
@property (nonatomic, strong) UITextField *pickup;
@property (nonatomic, strong) UITextField *destination;
@property (nonatomic, strong) UISwitch *mode;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightTextColor];
    
    self.pickup = [UITextField new];
    self.destination = [UITextField new];
    self.mode = [UISwitch new];

    self.pickup.translatesAutoresizingMaskIntoConstraints = NO;
    self.destination.translatesAutoresizingMaskIntoConstraints = NO;
    self.mode.translatesAutoresizingMaskIntoConstraints = NO;

    self.pickup.placeholder = @"Pick up address";
    self.destination.placeholder = @"Destionation address";
    [self.view addSubview:self.pickup];
    [self.view addSubview:self.destination];
    [self.view addSubview:self.mode];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pickup]-[_destination]-[_mode]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_pickup, _destination, _mode)]];
    
    for (UIView *subview in self.view.subviews) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview(80)]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(subview)]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
