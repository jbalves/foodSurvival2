//
//  StageSelectScene.m
//  foodSurvivel2
//
//  Created by Jeferson Barros Alves on 17/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "StageSelectScene.h"

#define NODENAME_STAGEGAME      @"stageGame"

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:NODENAME_STAGEGAME]) {
        [self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }
    
}

@end
