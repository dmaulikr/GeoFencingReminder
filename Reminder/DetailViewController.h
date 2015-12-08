//
//  DetailViewController.h
//  Reminder
//
//  Created by Regular User on 11/24/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

typedef void(^DetailViewControllerCompletion)(MKCircle *circle);

@interface DetailViewController : UIViewController

@property (copy, nonatomic) DetailViewControllerCompletion completion;
@property (strong, nonatomic) NSString *annotationTitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
