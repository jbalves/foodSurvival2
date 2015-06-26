//
//  GameCenter.m
//  JumpJack
//
//  Created by Eduarda Pinheiro on 26/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "GameCenter.h"
#import "ViewController.h"


@interface ViewController()

-(void)authenticateLocalPlayer;


@end

@implementation ViewController{
     BOOL _gameCenterEnable;
}


- (void)viewDidLoad {
    
    [self authenticateLocalPlayer];
    
    
}
//conexao ao game center
-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer=[GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {

            [self presentViewController:viewController animated:YES completion:nil];
        }
        
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                
                _gameCenterEnable = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnable = NO;
            }
        }
        
    };
    
}

@end
