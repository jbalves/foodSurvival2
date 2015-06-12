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
#define NODENAME_LEVEL1         @"Level1"

#define ACTION_JUMP             @"Jump"

@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *background;
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

    NSArray *nodes = self.children;
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"mainCamera"]) {
            mainCameraNode = node;
        } else if ([node.name isEqualToString:@"box"]) {
            SKSpriteNode *box = (SKSpriteNode *)node;
            box.texture = [SKTexture textureWithImageNamed:@"box"];
        } else if ([node.name isEqualToString:@"redBall"]) {
            SKSpriteNode *redBall = (SKSpriteNode *)node;
            redBall.texture = [SKTexture textureWithImageNamed:@"bola_vermelha"];
        } else if ([node.name isEqualToString:@"greenBall"]) {
            SKSpriteNode *greenBall = (SKSpriteNode *)node;
            greenBall.texture = [SKTexture textureWithImageNamed:@"bola_verde"];
        } else if ([node.name isEqualToString:@"jack"]) {
            SKSpriteNode *jack = (SKSpriteNode *)node;
            jack.physicsBody.contactTestBitMask = [Masks redBall] | [Masks greenBall];
        }
    }

    [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera"]];
    
    self.physicsWorld.contactDelegate = self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if (!jumping) {
        jumping = YES;
        [[node childNodeWithName:NODENAME_JACK] runAction:[SKAction actionNamed:ACTION_JUMP]];
    }
    
    if ([node.name isEqualToString:NODENAME_PAUSEBUTTON]) {
        self.scene.paused = YES;
        [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = NO;
    }
    
    if ([node.name isEqualToString:NODENAME_CONTINUE]) {
        self.scene.paused = NO;
        [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = YES;
    }
    
    if ([node.name isEqualToString:NODENAME_MENU]) {
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    }
    
    if ([node.name isEqualToString:NODENAME_RESTART]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    int A = contact.bodyA.categoryBitMask;
    int B = contact.bodyB.categoryBitMask;
    
    int fieldMaskA = contact.bodyA.fieldBitMask;
    int fieldMaskB = contact.bodyB.fieldBitMask;
    
//REDBALL       1 - 50
//GREENBALL     51-100
    
    NSArray *nodes = [self children];
    
    if ((A == [Masks jack] && B == [Masks ground]) ||
        (A == [Masks ground] && B == [Masks jack])) {
        jumping = NO;
    }
    
    if (A == [Masks jack] && B == [Masks redBall]) {
        badFood++;
        NSLog(@"bad: %d", badFood);
        
        if ((fieldMaskA >= 1 && fieldMaskA < 50) ||
            (fieldMaskB >= 1 && fieldMaskB < 50)) {
            
            for (SKSpriteNode *node in nodes) {
                if ((node.physicsBody.fieldBitMask == fieldMaskA) ||
                    (node.physicsBody.fieldBitMask == fieldMaskB)) {
                    [node removeFromParent];
                }
            }
        }
        
//        [mainCameraNode removeAllActions];
//        [mainCameraNode runAction:[SKAction actionNamed:@"moveCamera2"]];
        
    }
    
    
    NSLog(@"%d; %d", A, B);
    
    if (A == [Masks jack] && B == [Masks greenBall]) {
        goodFood++;
        NSLog(@"good: %d", goodFood);
        
        if ((fieldMaskA > 50 && fieldMaskA <= 100) ||
            (fieldMaskB > 50 && fieldMaskB <= 100)) {
            
            for (SKSpriteNode *node in nodes) {
                if ((node.physicsBody.fieldBitMask == fieldMaskA) ||
                    (node.physicsBody.fieldBitMask == fieldMaskB)) {
                    [node removeFromParent];
                }
            }
        }
        
    }
}

@end
