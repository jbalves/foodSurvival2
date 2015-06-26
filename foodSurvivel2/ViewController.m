//
//  GameViewController.m
//  foodSurvivel2
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "ViewController.h"
#import "Level1Scene.h"

@interface ViewController()

-(void)authenticateLocalPlayer;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
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

@implementation ViewController{
    BOOL _gameCenterEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    StartScene *scene = [StartScene unarchiveFromFile:@"StartScene"];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    scene.size = skView.bounds.size;
//    scene.size = CGSizeMake(667, 335);
    
    [skView presentScene:scene];
    
    [self authenticateLocalPlayer];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//conexao ao game cente

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer=[GKLocalPlayer localPlayer];//Instaciando o objeto GKLocalPlayer
    
   //view controller de visulaização do login que aparecerá automaticamente se o usuário não estiver logado
   localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
    if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
       
    else{
    if ([GKLocalPlayer localPlayer].authenticated) {
    
        _gameCenterEnable = YES;
    // A classe GKlocalPlayer fornece informaões sobre o ID do jogador, nome, amigo. Fornece também autenticação do jogador
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
