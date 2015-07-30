//
//  GameScene.m
//
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "Level1Scene.h"
#import <AVFoundation/AVFoundation.h>
#import "Sound.h"


@interface Level1Scene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *wallNode;
    SKSpriteNode *jack;
    SKSpriteNode *groundNode;
    SKSpriteNode *face1;
    SKSpriteNode *face2;
    SKSpriteNode *face3;
    SKTexture *happyFaceTexture;
    SKTexture *sadFaceTexture;
    SKLabelNode *score;
    
    AVAudioPlayer *somDeJogo;
    AVAudioPlayer *somDojack;
    
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

@implementation Level1Scene

-(void)didMoveToView:(SKView *)view {
    
    // [[Sound alloc] playSound:@"music" :@"mp3"];
    
    somDeJogo = [[Sound alloc] playSound:@"jogo" :@"mp3"];
    somDeJogo.numberOfLoops = 100;
    [somDeJogo play];

    //INIT OF BOOLS
    jumping = NO;
    
    //INIT OF COUNTERS
    badFood = 0;
    goodFood = 0;


    //INIT OF NODES
    mainCameraNode = [self childNodeWithName:@"mainCamera"];
    
    face1 = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"face1"];
    face2 = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"face2"];
    face3 = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"face3"];
    
    happyFaceTexture = [SKTexture textureWithImageNamed:@"happyFace"];
    sadFaceTexture = [SKTexture textureWithImageNamed:@"sadFace"];
    
    groundNode = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"ground"];
    
    wallNode = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"wall"];
    
    score = (SKLabelNode *)[mainCameraNode childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"Pontos %d", goodFood];
    
    jack = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"jack"];
    jack.physicsBody.contactTestBitMask = 2 | 3;
    jack.physicsBody.mass = 0.7;
    
    int countBadFood = 0;
    int countGoodFood = 0;
    
    NSArray *nodes = self.children;
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"box"]) {
            
            //BOX
            SKSpriteNode *box = (SKSpriteNode *)node;
            box.texture = [SKTexture textureWithImageNamed:@"box"];
            
        } else if ([node.name isEqualToString:@"redBall"]) {
          
            //BADFOOD
            SKSpriteNode *redBall = (SKSpriteNode *)node;

            if (countBadFood >= 0 && countBadFood < 3) {
                redBall.texture = [SKTexture textureWithImageNamed:@"sandwich"];
                countBadFood++;
            } else {
                
                redBall.texture = [SKTexture textureWithImageNamed:@"lolipop"];
            }
            
        } else if ([node.name isEqualToString:@"greenBall"]) {
            
            //GOODFOOD
            SKSpriteNode *greenBall = (SKSpriteNode *)node;
            
            if (countGoodFood >= 0 && countGoodFood < 3) {
                greenBall.texture = [SKTexture textureWithImageNamed:@"brocolis"];
                countGoodFood++;
            } else if (countGoodFood < 8) {
                greenBall.texture = [SKTexture textureWithImageNamed:@"orange"];
                countGoodFood++;
            } else {
                greenBall.texture = [SKTexture textureWithImageNamed:@"carrot"];
            }
            
        }
        
    }
    
    //MOVE CAMERA
    [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];
    
    //WORLD PHYSICS
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -8);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    

    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    self.userInteractionEnabled=YES;
    
    
    if ([jack intersectsNode:groundNode]) {
        jumping = NO;
    }
    
    if ([node.name isEqualToString:@"pauseButton"]) {
        self.scene.paused = YES;
        [mainCameraNode childNodeWithName:@"pauseNode"].hidden = NO;
        [mainCameraNode childNodeWithName:@"pauseButton"].hidden = YES;
        
        somDeJogo.numberOfLoops = 0;
        [somDeJogo pause];
        
    } else if ([node.name isEqualToString:@"continue"]) {
        self.scene.paused = NO;
        [mainCameraNode childNodeWithName:@"pauseNode"].hidden = YES;
        [mainCameraNode childNodeWithName:@"pauseButton"].hidden = NO;
        
        somDeJogo.numberOfLoops = 100;
        [somDeJogo play];
        
    } else if ([node.name isEqualToString:@"menu"]) {
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    } else if ([node.name isEqualToString:@"restart"]) {
        [self.scene.view presentScene:[Level1Scene unarchiveFromFile:@"Level1Scene"]];
    } else if ([node.name isEqualToString:@"tryAgain"]) {
        [self.scene.view presentScene:[Level1Scene unarchiveFromFile:@"Level1Scene"]];
    } else if (!jumping) {
        jumping = YES;

        [[Sound alloc] PLAY:@"jump" :@"mp3"];
        [jack.physicsBody applyImpulse:CGVectorMake(0, 330)];
        
    }

}

-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    jumping = YES;
}

- (void)update:(NSTimeInterval)currentTime {
    
    
    //CONTACT WITH GROUND
    if ([jack intersectsNode:groundNode]) {
        jumping = NO;
    }
    
    //CONTACT WITH BOX
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([jack intersectsNode:node]) {
            jumping = NO;
        }
    }];
    
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

            //Som contato
            [[Sound alloc] PLAY:@"button1" :@"mp3"];
            goodFood++;
            score.text = [NSString stringWithFormat:@"Pontos %d", goodFood];
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
    
    //FINISHED LEVEL
    SKSpriteNode *finishingBarrier = (SKSpriteNode *)[self childNodeWithName:@"finishingBarrier"];
    if ([jack intersectsNode:finishingBarrier]) {
        [self finishedLevel];
    }
    
}

//MAIN CAMERA ACTIONS (MOVE FASTER / SLOWER)
- (void) mainCameraAction {
    switch (badFood) {
        case 0:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];

            face1.texture = happyFaceTexture;
            face2.texture = happyFaceTexture;
            face3.texture = happyFaceTexture;
            
            break;
        case 1:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera2"]];
            
            face2.texture = happyFaceTexture;
            face3.texture = sadFaceTexture;
            
            break;
        case 2:
            [mainCameraNode removeAllActions];
            [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera3"]];
            
            face2.texture = sadFaceTexture;
            
            break;
        default:
            break;
    }
    


}

//FINISHED LEVEL
- (void) finishedLevel {
    
    //PAUSE THE GAME AND SET THE PAUSE BUTTON HIDDEN
    self.paused = YES;
    [mainCameraNode childNodeWithName:@"pauseButton"].hidden = YES;
    
    //CATCH THE SCORE LABEL ON SCENE AND DISPLAY THE SCORE OF THE PLAYER
    SKSpriteNode *finishNode = (SKSpriteNode *)[mainCameraNode childNodeWithName:@"finishedLevelNode"];
    finishNode.hidden = NO;
    SKSpriteNode *finishScreen = (SKSpriteNode *)[finishNode childNodeWithName:@"finishedLevelScreen"];
    SKLabelNode *finishScore = (SKLabelNode *)[finishScreen childNodeWithName:@"finishScoreNode"];
    finishScore.text = [NSString stringWithFormat:@"com %d pontos.", goodFood];
    
    //SAVE NEW SCORE + PREVIOUS SCORE ON USER DEFAULTS
    NSInteger previousScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    NSInteger newScore = previousScore + goodFood;
    [[NSUserDefaults standardUserDefaults] setInteger:newScore forKey:@"score"];
    
    //VERIFY IF ACTUAL SCORE IS THE NEW BEST SCORE AND SAVE ON USER DEFAULTS
    NSInteger bestScoreLevel1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestScoreLevel1"];
    if (bestScoreLevel1) {
        if (bestScoreLevel1 < goodFood) {
            [[NSUserDefaults standardUserDefaults] setInteger:goodFood forKey:@"bestScoreLevel1"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:goodFood forKey:@"bestScoreLevel1"];
    }
    
    somDeJogo.numberOfLoops = 0;
    [somDeJogo pause];
    
}


//GAMEOVER NODE
- (void) gameOver {
    
    somDeJogo.numberOfLoops = 0;
    [somDeJogo pause];
    
    face1.texture = sadFaceTexture;
    face2.texture = sadFaceTexture;
    face3.texture = sadFaceTexture;
    
    self.paused = YES;
    
    [mainCameraNode childNodeWithName:@"gameOverNode"].hidden = NO;
    [mainCameraNode childNodeWithName:@"pauseButton"].hidden = YES;
}

@end
