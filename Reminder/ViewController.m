//
//  ViewController.m
//  Reminder
//
//  Created by Regular User on 11/23/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

#import "ViewController.h"
#import "LocationController.h"
#import "DetailViewController.h"
#import "Reminder.h"

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface ViewController () <LocationControllerDelegate, MKMapViewDelegate,
PFLogInViewControllerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager; // is like a let getting a reference of location manager

@property (weak, nonatomic) IBOutlet MKMapView *mapView; // get a pointer to the mapView

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (strong, nonatomic) NSArray *parseReminders;

@end



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate: self]; // set to use MKMapViewDelegate
    [self.mapView.layer setCornerRadius: 20.0]; // make the map view have corners
    [self.mapView setShowsUserLocation:YES];
    
    
    
    // Parse login
    [self login];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //query Parse for the data
    
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
         NSLog(@"Successfully retrieved %lu parse reminders.", objects.count);
         self.parseReminders = [[NSArray alloc] initWithArray:objects];
         for( Reminder *reminder in self.parseReminders) {
             CLLocationCoordinate2D location = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
             if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                 // Create new region and start monitoring it.
                 
                 double dRadius = [reminder.radius doubleValue];
                 
                 CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location radius:dRadius identifier:reminder.name];
                 [[[LocationController sharedController]locationManager] startMonitoringForRegion: region];
                 
                 __weak typeof(self) weakSelf = self;
                 
                 [weakSelf.mapView addOverlay:[MKCircle circleWithCenterCoordinate: location radius: region.radius]];
                 
                 NSLog(@"%@", [[LocationController sharedController]locationManager]);
             }
         }
         
     } else {
         // Print details for the error if there is one.
         NSLog(@"Error: %@ %@", error, [error userInfo]);
     }
     }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start the location manager.
    [[LocationController sharedController]setDelegate:self];
    [[[LocationController sharedController]locationManager]startUpdatingLocation];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* If there isn't a current user logged in, create the memory and assign the delegate
   Bring up the login page from Parse
   If they are logged in create the logout button (setupAdditionalUI)
 */


- (void)setupAdditionalUI {
    UIBarButtonItem *signoutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signout)];
    self.navigationItem.leftBarButtonItem = signoutButton;
}


- (void)login {
    if (![PFUser currentUser]) {
        
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        loginViewController.delegate = self;
        
        [self presentViewController:loginViewController animated:NO completion:nil];
        
    } else { [self setupAdditionalUI]; }
}

// Logout of Parse and show the login screen

- (void)signout {
    [PFUser logOut];
    [self login];
}


            
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *annotationView = (MKAnnotationView *)sender;
            DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
                detailViewController.annotationTitle = annotationView.annotation.title;
                detailViewController.coordinate = annotationView.annotation.coordinate;
                        
                __weak typeof(self) weakSelf = self;
                        
                detailViewController.completion = ^(MKCircle *circle) {
                            
                [weakSelf.mapView removeAnnotation:annotationView.annotation];
                [weakSelf.mapView addOverlay:circle];
                            
                NSLog(@"%@", [[LocationController sharedController]locationManager]);
                            
                        };
                }
            }
    }
            




- (IBAction)handleLongPressGesture:(UIGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [gesture locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = touchMapCoordinate;
        newPoint.title = @"New Location";
        
        [self.mapView addAnnotation:newPoint];
    }
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

    
#pragma mark - LocationController
    
- (void)locationControllerDidUpdateLocation:(CLLocation *)location  {
        [self setRegionForCoordinate:MKCoordinateRegionMakeWithDistance(location.coordinate, 500.00, 500.00)];
    }

#pragma mark - MKMapViewDelegate


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) { return nil; }
    
    // Add view.
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    annotationView.annotation = annotation;
    
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    
    annotationView.canShowCallout = true;
    UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCallout;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
}

// Create the bubble for the region 

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleRenderer.strokeColor = [UIColor blueColor];
    circleRenderer.fillColor = [UIColor redColor];
    circleRenderer.alpha = 0.5;
    return circleRenderer;
}

// Delegate for Parse login

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

@end
