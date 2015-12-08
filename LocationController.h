//
//  LocationController.h
//  Reminder
//
//  Created by Regular User on 11/24/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

//

@import UIKit;
@import CoreLocation;

@protocol LocationControllerDelegate <NSObject>

- (void)locationControllerDidUpdateLocation:(CLLocation *)location;

@end

@interface LocationController : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) id delegate;

+ (LocationController *)sharedController;

@end