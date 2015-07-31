//
//  Sound.m
//  JumpJack
//
//  Created by Eduarda Pinheiro on 28/07/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "Sound.h"
@import AVFoundation;




@implementation Sound: SKNode

-(AVAudioPlayer *)playSound : (NSString *)fName :(NSString *) ext{
    //SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource: fName ofType:ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //NSURL *pathURL = [NSURL fileURLWithPath:path];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fName ofType:ext]];
        return [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
//        AudioServicesPlaySystemSound(audioEffect);
    }
    else{
        NSLog(@"error");
        return nil;
    }
    
    
}

-(void)PLAY:(NSString *)Name :(NSString *)ext{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource: Name ofType:ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fName ofType:ext]];
        //return [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
                AudioServicesPlaySystemSound(audioEffect);
    }
    else{
        NSLog(@"error");
    }
}

@end
