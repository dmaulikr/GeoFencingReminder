//
//  Reminder.h
//  Reminder
//
//  Created by Regular User on 11/28/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface Reminder : PFObject <PFSubclassing>


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) NSNumber *radius;

@end
