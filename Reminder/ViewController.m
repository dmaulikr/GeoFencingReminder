//
//  ViewController.m
//  Reminder
//
//  Created by Regular User on 11/23/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (strong, nonatomic) CLLocationManager* locationManager; // is like a let getting a reference of location manager

@property (weak, nonatomic) IBOutlet MKMapView *mapView; // get a pointer to the mapView

@property (weak, nonatomic) IBOutlet UIButton *locationButton;



@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPermissions];
    [self.mapView.layer setCornerRadius: 20.0]; // make the map view have corners
    [self.mapView setShowsUserLocation:YES]; 
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestPermissions {
    [self setLocationManager:[[CLLocationManager alloc]init]]; // create memory for location manager and do a setter?
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)setRegionForCoordinate:(MKCoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];
}


- (IBAction)locationButton:(UIButton *)sender {
    
    NSString *buttonTitle = sender.titleLabel.text;
    
    if ([buttonTitle isEqualToString:@"Location One"]) {
        NSLog(@"One");
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.35109699999998);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
        
        [self setRegionForCoordinate:region];
    }
    
    if ([buttonTitle isEqualToString:@"Location Two"]) {
        NSLog(@"Two");
    }
    
    if ([buttonTitle isEqualToString:@"Location Three"]) {
        NSLog(@"Three");
    }
    
}
@end
