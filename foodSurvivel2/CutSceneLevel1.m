//
//  CutSceneLevel1.m
//  foodSurvivel2
//
//  Created by Jeferson Barros Alves on 19/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "CutSceneLevel1.h"

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

-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    [self.scene.view presentScene:[StageSelectScene unarchiveFromFile:@"StageSelectScene"]];

}

-(void)update:(NSTimeInterval)currentTime {
    
}


@end