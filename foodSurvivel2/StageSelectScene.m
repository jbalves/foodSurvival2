//
//  StageSelectScene.m
//  foodSurvivel2
//
//  Created by Jeferson Barros Alves on 17/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "StageSelectScene.h"

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

@implementation StageSelectScene

@end
