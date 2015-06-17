//
//  GameScene.m
//
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *wallNode;
    SKSpriteNode *jack;
    SKSpriteNode *groundNode;
    SKLabelNode *score;
    int badFood;
    int goodFood;
    CGPoint jacksDefaultPosition;
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

    jacksDefaultPosition.x = -146.440964;
    jacksDefaultPosition.y = -79.361984;
    
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
    
    //WORLD PHYSICS
    self.physicsWorld.contactDelegate = self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //JACK'S JUMP
    if (!jumping) {
        jumping = YES;
        [jack runAction:[SKAction actionNamed:@"Jump"] withKey:@"jumping"];
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

}

- (void)update:(NSTimeInterval)currentTime {
    
    //CONTACT WITH GROUND
    if ([jack intersectsNode:groundNode]) {
//        [jack runAction:[SKAction actionNamed:@"MoveToDefaultPosition"]];
        jumping = NO;
    }
    
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
}

@end
