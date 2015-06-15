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

#define ACTION_JUMP             @"Jump"

@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *background;
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
    
    NSArray *nodes = self.children;
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"box"]) {
            
            //AJUSTES DA BOX
            SKSpriteNode *box = (SKSpriteNode *)node;
            box.texture = [SKTexture textureWithImageNamed:@"box"];
            
        } else if ([node.name isEqualToString:@"ground"]){
            
            //AJUSTES GROUND
            SKSpriteNode *ground = (SKSpriteNode *)node;
            ground.physicsBody.collisionBitMask = 0;
            ground.physicsBody.categoryBitMask = [Masks ground];
            ground.physicsBody.contactTestBitMask = [Masks jack];
            
        } else if ([node.name isEqualToString:@"redBall"]) {
          
            //AJUSTES DA BADFOOD
            SKSpriteNode *redBall = (SKSpriteNode *)node;
            redBall.texture = [SKTexture textureWithImageNamed:@"bola_vermelha"];
            redBall.physicsBody.collisionBitMask = 10;
            redBall.physicsBody.categoryBitMask = [Masks redBall];
            redBall.physicsBody.contactTestBitMask = [Masks jack];

        } else if ([node.name isEqualToString:@"greenBall"]) {
            
            //AJUSTES DA GOODFOOD
            SKSpriteNode *greenBall = (SKSpriteNode *)node;
            greenBall.texture = [SKTexture textureWithImageNamed:@"bola_verde"];
            greenBall.physicsBody.collisionBitMask = 10;
            greenBall.physicsBody.categoryBitMask = [Masks greenBall];
            greenBall.physicsBody.contactTestBitMask = [Masks jack];

        } else if ([node.name isEqualToString:@"jack"]) {
            
            //AJUSTES DO JACK
            SKSpriteNode *jack = (SKSpriteNode *)node;
            jack.physicsBody.collisionBitMask = 0;
            jack.physicsBody.categoryBitMask = [Masks jack];
            jack.physicsBody.contactTestBitMask = [Masks redBall] | [Masks greenBall] | [Masks ground];
            
        }
    }
    score = (SKLabelNode *)[mainCameraNode childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"Score %d", goodFood];
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
        [[node childNodeWithName:NODENAME_JACK] runAction:[SKAction actionNamed:ACTION_JUMP]];
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

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody = contact.bodyA;
    SKPhysicsBody *secondBody = contact.bodyB;
    
    //CONTATO COM GROUND
    if (firstBody.categoryBitMask == [Masks ground] && secondBody.categoryBitMask == [Masks jack]) {
        jumping = NO;
    }
    
    //CONTATO COM BADFOOD
    if (firstBody.categoryBitMask == [Masks jack] && secondBody.categoryBitMask == [Masks redBall]) {
        badFood++;
        score.text = [NSString stringWithFormat:@"Score %d", goodFood];
        [secondBody.node removeFromParent];
        
        if (badFood == 5) {
            [self gameOver];
        } else {
            [self mainCameraAction];
        }
    }
    
    //CONTATO COM GOODFOOD
    if (firstBody.categoryBitMask == [Masks jack] && secondBody.categoryBitMask == [Masks greenBall]) {
        goodFood++;
        score.text = [NSString stringWithFormat:@"Score %d", goodFood];
        [secondBody.node removeFromParent];
        
        if (badFood > 0) {
            badFood --;
            [self mainCameraAction];
        }
    }
    
}

//AÇÕES DA CAMERA PRINCIPAL (MOVER MAIS RÁPIDO / MAIS LENTO)
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

//GAMEOVER
- (void) gameOver {
    self.paused = YES;
    [mainCameraNode childNodeWithName:@"gameOverNode"].hidden = NO;
    [mainCameraNode childNodeWithName:NODENAME_PAUSEBUTTON].hidden = YES;
}

@end
