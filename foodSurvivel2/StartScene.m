//
//  StartScene.m
//  foodSurvivel2
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "StartScene.h"

#define NODENAME_FOODINFO       @"foodInfo"
#define NODENAME_INITGAME       @"initGame"
#define NODENAME_AVATAR         @"avatar"


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


@implementation StartScene

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:NODENAME_INITGAME]) {
        [self.scene.view presentScene:[StageSelectScene unarchiveFromFile:@"StageSelectScene"]];
        //[self.scene.view presentScene:[GameScene unarchiveFromFile:@"GameScene"]];
    }
    
    if ([node.name isEqualToString:NODENAME_FOODINFO]) {
        [self.scene.view presentScene:[FoodInfoScene unarchiveFromFile:@"FoodInfoScene"]];
    }
}

@end
