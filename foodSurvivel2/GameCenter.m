//
//  GameCenter.m
//  JumpJack
//
//  Created by Eduarda Pinheiro on 26/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "GameCenter.h"
#import "ViewController.h"


NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";

@implementation GameCenter{
    BOOL _enableGameCenter;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        
        [self setLastError:error];
        
        if(viewController != nil) {
            //4
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            _enableGameCenter = YES;
        } else {
            //6
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]postNotificationName:PresentAuthenticationViewController object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}



+ (instancetype)sharedGameCenter
{
    static GameCenter *sharedGK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGK = [[GameCenter alloc] init];
    });
    return sharedGK;
}

@end
