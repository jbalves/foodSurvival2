//
//  GameViewController.m
//  foodSurvivel2
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "ViewController.h"
#import "Level1Scene.h"
#import "GameCenter.h"


@interface ViewController() {
    BOOL _gameCenterEnabled;
    NSString *_leaderboardIdentifier;
}

-(void)authenticateLocalPlayer;

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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self authenticateLocalPlayer];

    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    StartScene *scene = [StartScene unarchiveFromFile:@"StartScene"];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    scene.size = skView.bounds.size;
//    scene.size = CGSizeMake(667, 335);
    
    [skView presentScene:scene];
    
}

//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    } else {
//        return UIInterfaceOrientationMaskAll;
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
//
//
//
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
//
//-(void)authenticateLocalPlayer{
//    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//    
//    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
//        if (viewController != nil) {
//            [self presentViewController:viewController animated:YES completion:nil];
//        }
//        else{
//            if ([GKLocalPlayer localPlayer].authenticated) {
//                _gameCenterEnabled = YES;
//                
//                // Get the default leaderboard identifier.
//                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
//                    
//                    if (error != nil) {
//                        NSLog(@"%@", [error localizedDescription]);
//                    }
//                    else{
//                        _leaderboardIdentifier = leaderboardIdentifier;
//                    }
//                }];
//            }
//            
//            else{
//                _gameCenterEnabled = NO;
//            }
//        }
//    };
//}





@end
