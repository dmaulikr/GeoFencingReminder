//
//  Reminder.m
//  Reminder
//
//  Created by Regular User on 11/28/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder


@dynamic name;
@dynamic location;
@dynamic radius;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Reminder";
}

@end



