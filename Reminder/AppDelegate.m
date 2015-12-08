//
//  AppDelegate.m
//  Reminder
//
//  Created by Regular User on 11/23/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

#import "AppDelegate.h"
@import Parse;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"Yvq5OmUqXlNYWQGi1V4cGwyCXY3gbQV3Idk3aPdx" clientKey:@"B6I1tlHhOOpPN2hwfv3PRiIo251vo9jsM9QJ98jM"];

    return YES;
}

- (void)registerForNotifications {
    [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}

@end
