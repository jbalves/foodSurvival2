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


@interface ViewController()

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
@implementation ViewController

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



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    
    [[GameCenter sharedGameCenter]
     authenticateLocalPlayer];
}

- (void)showAuthenticationViewController
{
    GameCenter *gameKitCenter = [GameCenter sharedGameCenter];
    
    [self presentViewController: gameKitCenter.authenticationViewController animated:YES
completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






@end
