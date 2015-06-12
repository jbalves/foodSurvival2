//
//  GameScene.m
//  foodSurvivel2
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

#define ACTION_JUMP         @"Jump"

@interface GameScene () {
    BOOL jumping;
    SKNode *mainCameraNode;
    SKSpriteNode *background;
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
    
    NSArray *nodes = self.children;
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"mainCamera"]) {
            mainCameraNode = node;
            [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = YES;
        }
    }
    
    [mainCameraNode addChild:[self background]];
    [mainCameraNode childNodeWithName:@"background"].hidden = YES;
    
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
//        [mainCameraNode childNodeWithName:@"background"].hidden = NO;
        [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = NO;
    }
    
    if ([node.name isEqualToString:NODENAME_CONTINUE]) {
        self.scene.paused = NO;
//        [mainCameraNode childNodeWithName:@"background"].hidden = YES;
        [mainCameraNode childNodeWithName:NODENAME_PAUSE].hidden = YES;
    }
    
    if ([node.name isEqualToString:NODENAME_MENU]) {
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    }
    
    if ([node.name isEqualToString:NODENAME_RESTART]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }
}

- (SKSpriteNode *) background {
    background = [SKSpriteNode new];
    background.name = @"background";
    background.color = [UIColor grayColor];
    background.alpha = 0.3;
    background.size = self.frame.size;
    background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    background.zPosition = 5;
    return background;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    int A = contact.bodyA.categoryBitMask;
    int B = contact.bodyB.categoryBitMask;
    
    if ((A == [Masks jack] && B == [Masks ground]) ||
        (A == [Masks ground] && B == [Masks jack])) {
        jumping = NO;
    }
}

@end
