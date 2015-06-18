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
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Este método libera recursos compartilhados, salva dados do usuário, invalida temporizadores
    //armazena informações sobre o estado atual da aplicação
    
    //Este objeto especifica uma notificacão que um aplicativo pode agendar para a apresentação em uma data e hora específica
    UILocalNotification *note=[[UILocalNotification alloc]init];
    [note setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    [note setTimeZone:[NSTimeZone defaultTimeZone]];
    [note setAlertBody:@"Jack está ficando gordo. Ajude-o a perder peso"];
    
    [application setScheduledLocalNotifications:[NSArray arrayWithObject:note]];//método agenda a entrega da notificação
    
    //note.soundName=@"mp3"; som de notificação
    
    //Essa condição  mostra a exibição de alerta para o usuário para pedir permissão.
    
if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) { [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];

    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
