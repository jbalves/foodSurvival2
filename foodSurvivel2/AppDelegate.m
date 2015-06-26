//
//  AppDelegate.m
//  foodSurvivel2
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    

    //PERMISSION TO SHOW NOTIFICATION
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
//                                                                             settingsForTypes:UIUserNotificationTypeAlert |
//                                                                             UIUserNotificationTypeSound |
//                                                                             UIUserNotificationTypeBadge categories:nil]];
//    }
    
    //[self authenticateLocalPlayer];
    
    return YES;
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //NOTIFICATIONS
//    NSDate *alarmTime = [NSDate dateWithTimeIntervalSinceNow:21600];
//    UIApplication *app = [UIApplication sharedApplication];
//    UILocalNotification *note = [[UILocalNotification alloc] init];
//    
//    if (note) {
//        note.fireDate = alarmTime;
//        note.timeZone = [NSTimeZone defaultTimeZone];
//        note.repeatInterval = NSCalendarUnitHour*6;
//        note.alertBody = @"Jack está ficando gordo. Ajude-o a perder peso.";
//        [app setScheduledLocalNotifications:[NSArray arrayWithObject:note]];
//    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *oldNotifications = [app scheduledLocalNotifications];
//    
//    if ([oldNotifications count] > 0) {
//        [app cancelAllLocalNotifications];
//    }
}





@end
