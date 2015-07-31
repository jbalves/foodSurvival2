//
//  CutSceneLevel1.m
//  foodSurvivel2
//
//  Created by Jeferson Barros Alves on 19/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "CutSceneLevel1.h"
#import "Sound.h"

@interface CutSceneLevel1 () {
    
    SKAction *goodAction;
    SKNode *mainCameraNode;
    SKSpriteNode *jack;
    BOOL endMove;
    BOOL didJump;
    
    AVAudioPlayer *somDoJack;
    AVAudioPlayer *somDoBotao;
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
    didJump = NO;
    mainCameraNode = [self childNodeWithName:@"mainCameraNode"];
    jack = (SKSpriteNode *)[self childNodeWithName:@"jack"];
    [self childNodeWithName:@"informationTap"].hidden = YES;
    [self childNodeWithName:@"face1"].hidden = YES;
    [self childNodeWithName:@"face2"].hidden = YES;
    [self childNodeWithName:@"face3"].hidden = YES;
    [self childNodeWithName:@"scoreLabel"].hidden = YES;
    [self childNodeWithName:@"informationGood"].hidden = YES;
    

    SKAction *badAction = [SKAction sequence:@[[SKAction runBlock:^{
        [mainCameraNode runAction:[SKAction actionNamed:@"moveToBadFood"]];
    }], [SKAction waitForDuration:4.0f], [SKAction runBlock:^{
        [jack runAction:[SKAction actionNamed:@"moveToBadFoodJack"]];
    }], [SKAction waitForDuration:2.0f] ,[SKAction runBlock:^{
        [self childNodeWithName:@"face1"].hidden = NO;
        [self childNodeWithName:@"face2"].hidden = NO;
        [self childNodeWithName:@"face3"].hidden = NO;
        [self childNodeWithName:@"redBall"].hidden = YES;
        [self childNodeWithName:@"badFoodAnimation"].hidden = YES;
        [self childNodeWithName:@"informationBad"].hidden = YES;
    }], [SKAction waitForDuration:0.5f], [SKAction runBlock:^{
        [mainCameraNode runAction:[SKAction actionNamed:@"moveToChubby"]];
    }], [SKAction waitForDuration:2.0f], [SKAction runBlock:^{
        [mainCameraNode runAction:[SKAction actionNamed:@"moveCameraToDefault"]];
    }], [SKAction waitForDuration:2.0f], [SKAction runBlock:^{
        SKSpriteNode *face3 = (SKSpriteNode *)[self childNodeWithName:@"face3"];
        face3.texture = [SKTexture textureWithImageNamed:@"happyFace"];
    }], [SKAction runBlock:^{
        [jack runAction:[SKAction actionNamed:@"jacksDefaultPosition"]];
        [self childNodeWithName:@"redBall"].hidden = NO;
        [self childNodeWithName:@"badFoodAnimation"].hidden = NO;
    }], [SKAction waitForDuration:1.0f], [SKAction runBlock:^{
        [mainCameraNode runAction:[SKAction actionNamed:@"showFood"]];
        [self childNodeWithName:@"informationGood"].hidden = NO;
    }], [SKAction waitForDuration:4.0f], [SKAction runBlock:^{
        [jack runAction:[SKAction actionNamed:@"firstMove"]];
    }], [SKAction waitForDuration:0.5f], [SKAction runBlock:^{
        [self childNodeWithName:@"informationTap"].hidden = NO;
        endMove = YES;
    }]
    ]];
    
    [self runAction:badAction];
    
    
    goodAction = [SKAction sequence:@[[SKAction runBlock:^{
        [jack runAction:[SKAction actionNamed:@"tapJump"]];
    }], [SKAction waitForDuration:0.5f], [SKAction runBlock:^{
        [self childNodeWithName:@"greenBall"].hidden = YES;
        [self childNodeWithName:@"goodFoodAnimation"].hidden = YES;
        [self childNodeWithName:@"scoreLabel"].hidden = NO;
        [self childNodeWithName:@"informationGood"].hidden = YES;
        [self childNodeWithName:@"informationTap"].hidden = YES;
    }], [SKAction waitForDuration:1.0f], [SKAction runBlock:^{
        [mainCameraNode runAction:[SKAction actionNamed:@"showScore"]];
    }], [SKAction waitForDuration:5.0f], [SKAction runBlock:^{
        [self.scene.view presentScene:[Level1Scene unarchiveFromFile:@"Level1Scene"]
                           transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
    }]
    ]];

}

-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if (endMove && !didJump) {

        [[Sound alloc] PLAY:@"jump" :@"mp3"];
       
        didJump = YES;
        [self runAction:goodAction];
    }
    
    if ([node.name isEqualToString:@"skipTutorial"]) {
        //Som tutorial
        [[Sound alloc] PLAY:@"button1" :@"mp3"];
      
        [self.scene.view presentScene:[Level1Scene unarchiveFromFile:@"Level1Scene"]
                           transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];        
    }
}

@end