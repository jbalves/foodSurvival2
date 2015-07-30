//
//  GameViewController.m
//  foodSurvivel2
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "ViewController.h"
#import "Level1Scene.h"
#import "GameCenter.h"


@interface ViewController()

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    return scene;
}

@end

@implementation ViewController {
    BOOL _gameCenterEnabled;
    GKLocalPlayer *_localPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView * skView = (SKView *)self.view;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    StartScene *scene = [StartScene unarchiveFromFile:@"StartScene"];
    
    [skView presentScene:scene];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self authenticateLocalPlayer];
}

- (void)authenticateLocalPlayer{
    
    _localPlayer = [GKLocalPlayer localPlayer];
    _localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        
        if (viewController != nil) {
//            [self presentViewController:viewController animated:YES completion:nil];
            NSLog(@"user NOT logged in Game Center");
        } else {
            NSLog(@"user logged in Game Center");
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                NSLog(@"user authenticated");
            } else {
                _gameCenterEnabled = NO;
                NSLog(@"user NOT authenticated");
            }
        }
        
    };
    
}



//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
//    
//    [[GameCenter sharedGameCenter]
//     authenticateLocalPlayer];
//}
//
//- (void)showAuthenticationViewController
//{
//    GameCenter *gameKitCenter = [GameCenter sharedGameCenter];
//    
//    [self presentViewController: gameKitCenter.authenticationViewController animated:YES
//completion:nil];
//}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
