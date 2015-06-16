//
//  GameScene.m
//
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "GameScene.h"

#define NODENAME_JACK           @"jack"
#define NODENAME_PAUSEBUTTON    @"pauseButton"
#define NODENAME_CONTINUE       @"continue"
#define NODENAME_MENU           @"menu"
#define NODENAME_RESTART        @"restart"
#define NODENAME_PAUSE          @"pauseNode"
#define NODENAME_TRYAGAIN       @"tryAgain"
#define NODENAME_LEVEL1         @"Level1"

@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    NSMutableArray *redBallNodes;
    NSMutableArray *greenBallNodes;
    SKSpriteNode *wallNode;
    SKLabelNode *score;
    int badFood;
    int goodFood;
}

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
    
    return scene;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    jumping = NO;
    badFood = 0;
    goodFood = 0;
    mainCameraNode = [self childNodeWithName:@"mainCamera"];
    wallNode = [mainCameraNode childNodeWithName:@"wall"];
    
    greenBallNodes = [[NSMutableArray alloc] init];
    redBallNodes = [[NSMutableArray alloc] init];
    
    NSArray *nodes = self.children;
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"box"]) {
            
            //AJUSTES BOX
            SKSpriteNode *box = (SKSpriteNode *)node;
            box.texture = [SKTexture textureWithImageNamed:@"box"];
            
        } else if ([node.name isEqualToString:@"ground"]){
            
            //AJUSTES GROUND
            SKSpriteNode *ground = (SKSpriteNode *)node;
            ground.physicsBody.collisionBitMask = 1 | 3 | 4;
            
        } else if ([node.name isEqualToString:@"redBall"]) {
          
            //AJUSTES BADFOOD
            SKSpriteNode *redBall = (SKSpriteNode *)node;
            redBall.texture = [SKTexture textureWithImageNamed:@"bola_vermelha"];
            [redBallNodes addObject:redBall];
            
        } else if ([node.name isEqualToString:@"greenBall"]) {
            
            //AJUSTES GOODFOOD
            SKSpriteNode *greenBall = (SKSpriteNode *)node;
            greenBall.texture = [SKTexture textureWithImageNamed:@"bola_verde"];
            [greenBallNodes addObject:greenBall];
    
        }
    }
    
    //AJUSTE JACK
    SKSpriteNode *jack = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"jack"];
    jack.physicsBody.collisionBitMask = 2 | 3;
    
    //INITIATE SCORE
    score = (SKLabelNode *)[mainCameraNode childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"Score %d", goodFood];
    
    //MOVE CAMERA
    [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];
    
    self.physicsWorld.contactDelegate = self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //PULO DO JACK
    if (!jumping) {
        jumping = YES;
        [[node childNodeWithName:NODENAME_JACK] runAction:[SKAction actionNamed:@"Jump"]];
    }
    
    //CLICK NO BOTAO DE PAUSE
    if ([node.name isEqualToString:NODENAME_PAUSEBUTTON]) {
        self.scene.paused = YES;
        [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = NO;
    }
    
    //CLICK NO BOTAO CONTINUE
    if ([node.name isEqualToString:NODENAME_CONTINUE]) {
        self.scene.paused = NO;
        [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = YES;
    }
    
    //CLICK NO BOTAO MENU
    if ([node.name isEqualToString:NODENAME_MENU]) {
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    }
    
    //CLICK NO BOTAO RESTART
    if ([node.name isEqualToString:NODENAME_RESTART]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }

    //CLICK NO BOTAO TRY AGAIN
    if ([node.name isEqualToString:NODENAME_TRYAGAIN]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }

}

- (void)update:(NSTimeInterval)currentTime {
    SKNode *jack = [mainCameraNode childNodeWithName:@"jack"];
    SKNode *ground = [mainCameraNode childNodeWithName:@"ground"];
    
    //CONTACT WITH GROUND
    if ([jack intersectsNode:ground]) {
        jumping = NO;
    }
    
    //CONTACT WITH BADFOOD
    for (SKNode *redBall in redBallNodes) {
        if ([jack intersectsNode:redBall]) {
            badFood++;
            score.text = [NSString stringWithFormat:@"Score %d", goodFood];
            [redBall removeFromParent];
            if (badFood == 5) {
                [self gameOver];
            } else {
                [self mainCameraAction];
            }
        }
    }
    
    //CONTACT WITH GOODFOOD
    for (SKNode *greenBall in greenBallNodes) {
        if ([jack intersectsNode:greenBall]) {
            goodFood++;
            score.text = [NSString stringWithFormat:@"Score %d", goodFood];
            [greenBall removeFromParent];
            
            if (badFood > 0) {
                badFood --;
                [self mainCameraAction];
            }
        }
    }
    
    //JACK RUN OUT FROM EDGE
    if ([jack intersectsNode:wallNode]) {
        [self gameOver];
    }
}


//MAIN CAMERA ACTIONS (MOVE FASTER / SLOWER)
- (void) mainCameraAction {
    switch (badFood) {
        case 1:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];
            break;
        case 2:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera2"]];
            break;
        case 3:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera3"]];
            break;
        case 4:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera4"]];
            break;
        default:
            break;
    }
}

//GAMEOVER NODE
- (void) gameOver {
    self.paused = YES;
    [mainCameraNode childNodeWithName:@"gameOverNode"].hidden = NO;
    [mainCameraNode childNodeWithName:NODENAME_PAUSEBUTTON].hidden = YES;
}

@end
