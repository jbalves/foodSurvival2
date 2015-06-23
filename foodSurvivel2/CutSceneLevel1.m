//
//  CutSceneLevel1.m
//  foodSurvivel2
//
//  Created by Jeferson Barros Alves on 19/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "CutSceneLevel1.h"

@interface CutSceneLevel1 () {
    
    SKNode *mainCameraNode;
    SKSpriteNode *jack;
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


@implementation CutSceneLevel1


-(void)didMoveToView:(SKView *)view {

    mainCameraNode = [self childNodeWithName:@"mainCameraNode"];
    jack = (SKSpriteNode *)[self childNodeWithName:@"jack"];

    SKAction *action = [SKAction sequence:
                        @[[SKAction runBlock:^{
        [mainCameraNode runAction:[SKAction actionNamed:@"showFood"]];
    }],
                          [SKAction waitForDuration:4.0f],
                          [SKAction runBlock:^{
        [jack runAction:[SKAction actionNamed:@"firstMove"]];
    }]]];
    
    [self runAction:action];
}

-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"informationTap"]) {
        [self childNodeWithName:@"informationTap"].hidden = YES;
        [self childNodeWithName:@"informationGood"].hidden = YES;
        [jack runAction:[SKAction actionNamed:@"tapJump"]];
    }
}

-(void)update:(NSTimeInterval)currentTime {
    //CONTACT WITH GOOD FOOD
    [self enumerateChildNodesWithName:@"greenBall" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([node intersectsNode:jack]) {
            [node removeFromParent];
            [SKAction waitForDuration:2.0f];
            [self.scene.view presentScene:[Level1Scene unarchiveFromFile:@"Level1Scene"] transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];

        }
    }];
    
}


@end