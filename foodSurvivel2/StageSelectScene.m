//
//  StageSelectScene.m
//  foodSurvivel2
//
//  Created by Jeferson Barros Alves on 17/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "StageSelectScene.h"
#import "Sound.h"

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

@implementation StageSelectScene

- (void)didMoveToView:(nonnull SKView *)view {
    //SET THE BEST SCORE FROM LEVEL 1 AT THE LABEL
    SKLabelNode *bestScoreLevel1Label = (SKLabelNode *)[self childNodeWithName:@"bestScoreLevel1"];
    NSInteger bestScoreLevel1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"bestScoreLevel1"];

    //VERIFY IF BEST SCORE OF LEVEL 1 IS NOT NULL, IF NOT SET THE SCORE ON USER DEFAULTS, IF YES PUT SOME DEFAULT TEXT
    if (bestScoreLevel1) {
        bestScoreLevel1Label.text = [NSString stringWithFormat:@"Recorde %ld", bestScoreLevel1];
    } else {
        bestScoreLevel1Label.text = @"Nenhum recorde";
        bestScoreLevel1Label.fontSize = 8;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //LEVEL 1 CLICKED, GO TO LEVEL 1 SCENE
    if ([node.name isEqualToString:@"Level1"] ||
        [node.name isEqualToString:@"level1Label"] ||
        [node.name isEqualToString:@"bestScoreLevel1"]) {
        [self.scene.view presentScene:[CutSceneLevel1 unarchiveFromFile:@"CutSceneLevel1"]
                           transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
    //Som nivel 1
        
        [[Sound alloc] PLAY:@"button1" :@"mp3"];
    }

    //BACK CLICKED
    if ([node.name isEqualToString:@"backButton"]) {
        
        [[Sound alloc] PLAY:@"button1" :@"mp3"];
    
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    
      
    }
    
}

@end
