//
//  GameScene.m
//
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "GameScene.h"

<<<<<<< HEAD
#define NODENAME_JACK           @"jack"
#define NODENAME_PAUSEBUTTON    @"pauseButton"
#define NODENAME_CONTINUE       @"continue"
#define NODENAME_MENU           @"menu"
#define NODENAME_RESTART        @"restart"
#define NODENAME_PAUSE          @"pauseNode"
#define NODENAME_LEVEL1         @"Level1"


#define ACTION_JUMP         @"Jump"

@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *background;
    int *countScore;
    SKLabelNode *score;

=======
@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *wallNode;
    SKSpriteNode *jack;
    SKSpriteNode *groundNode;
    SKLabelNode *score;
    int badFood;
    int goodFood;
>>>>>>> master
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
    
    //INIT OF BOOLS
    jumping = NO;
<<<<<<< HEAD
    countScore = 0;
=======
    
    //INIT OF COUNTERS
    badFood = 0;
    goodFood = 0;


    //INIT OF NODES
    mainCameraNode = [self childNodeWithName:@"mainCamera"];
    
    groundNode = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"ground"];
    
    wallNode = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"wall"];
    
    score = (SKLabelNode *)[mainCameraNode childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"Score %d", goodFood];
    
    jack = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"jack"];
    jack.physicsBody.collisionBitMask = 2 | 3;
    
>>>>>>> master
    NSArray *nodes = self.children;
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"box"]) {
            
            //BOX
            SKSpriteNode *box = (SKSpriteNode *)node;
            box.texture = [SKTexture textureWithImageNamed:@"box"];
            
        } else if ([node.name isEqualToString:@"ground"]){
            
            //GROUND
            SKSpriteNode *ground = (SKSpriteNode *)node;
            ground.physicsBody.collisionBitMask = 1 | 3 | 4;
            
        } else if ([node.name isEqualToString:@"redBall"]) {
          
            //BADFOOD
            SKSpriteNode *redBall = (SKSpriteNode *)node;
            redBall.texture = [SKTexture textureWithImageNamed:@"bola_vermelha"];
            
        } else if ([node.name isEqualToString:@"greenBall"]) {
            
            //GOODFOOD
            SKSpriteNode *greenBall = (SKSpriteNode *)node;
            greenBall.texture = [SKTexture textureWithImageNamed:@"bola_verde"];
    
        }
    }
    
    //MOVE CAMERA
    [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];
    
<<<<<<< HEAD
    mainCameraNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:mainCameraNode.frame];
    self.physicsWorld.contactDelegate = self;
    
    [mainCameraNode childNodeWithName:@"gameOver"].hidden = YES;
=======
    //WORLD PHYSICS
    self.physicsWorld.contactDelegate = self;
    
>>>>>>> master
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    score =(SKLabelNode *)[mainCameraNode childNodeWithName:@"score"];
    

    
    //JACK'S JUMP
    if (!jumping) {
        jumping = YES;
<<<<<<< HEAD
        [[node childNodeWithName:NODENAME_JACK] runAction:[SKAction actionNamed:ACTION_JUMP]];
        countScore = countScore+1;
        score.text = [NSString stringWithFormat:@"Score: %d",(int)countScore];
=======
        [jack runAction:[SKAction actionNamed:@"Jump"] withKey:@"jumping"];
>>>>>>> master
    }
    
    //PAUSE CLICKED
    if ([node.name isEqualToString:@"pauseButton"]) {
        self.scene.paused = YES;
        [mainCameraNode childNodeWithName:@"pauseNode"].hidden = NO;
    }
    
    //CONTINUE CLICKED
    if ([node.name isEqualToString:@"continue"]) {
        self.scene.paused = NO;
        [mainCameraNode childNodeWithName:@"pauseNode"].hidden = YES;
    }
    
    //MAIN MENU CLICKED
    if ([node.name isEqualToString:@"menu"]) {
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    }
    
    //RESTART CLICKED
    if ([node.name isEqualToString:@"restart"]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }

    //TRY AGAIN CLICED
    if ([node.name isEqualToString:@"tryAgain"]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }
<<<<<<< HEAD
    
}
=======
>>>>>>> master

}

- (void)update:(NSTimeInterval)currentTime {
    
    //CONTACT WITH GROUND
    if ([jack intersectsNode:groundNode]) {
//        [jack runAction:[SKAction actionNamed:@"MoveToDefaultPosition"]];
        jumping = NO;
    }
    
<<<<<<< HEAD
    if ((A == [Masks jack] && B == [Masks wall]) ||
        (A == [Masks wall] && B == [Masks jack])) {
        NSLog(@"Contato com wall");
        //chamar metodo gameOver, ao invés da gambiarra abaixo
        //self.scene.paused = YES;
        //[mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = NO;
        [self gameOver];


    }
}

- (void) gameOver {
    self.paused = YES;
    [mainCameraNode childNodeWithName:@"gameOver"].hidden = NO;
    [mainCameraNode childNodeWithName:NODENAME_PAUSEBUTTON].hidden = YES;
=======
    //CONTACT WITH BADFOOD
    [self enumerateChildNodesWithName:@"redBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([node intersectsNode:jack]) {
            [node removeFromParent];
            badFood++;
            if (badFood == 3) {
                [self gameOver];
            } else {
                [self mainCameraAction];
            }
        }
    }];
    
    //CONTACT WITH GOOD FOOD
    [self enumerateChildNodesWithName:@"greenBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([node intersectsNode:jack]) {
            [node removeFromParent];
            goodFood++;
            score.text = [NSString stringWithFormat:@"Score %d", goodFood];
            if (badFood > 0) {
                badFood --;
                [self mainCameraAction];
            }
        }
    }];
    
    //JACK RUN OUT FROM THE SCENE
    if ([jack intersectsNode:wallNode]) {
        [self gameOver];
    }
    
}

//MAIN CAMERA ACTIONS (MOVE FASTER / SLOWER)
- (void) mainCameraAction {
    switch (badFood) {
        case 0:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];
            break;
        case 1:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera2"]];
            break;
        case 2:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera3"]];
            break;
        default:
            break;
    }
}

//GAMEOVER NODE
- (void) gameOver {
    self.paused = YES;
    [mainCameraNode childNodeWithName:@"gameOverNode"].hidden = NO;
    [mainCameraNode childNodeWithName:@"pauseButton"].hidden = YES;
>>>>>>> master
}

@end
