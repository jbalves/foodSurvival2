//
//  Sound.h
//  JumpJack
//
//  Created by Eduarda Pinheiro on 28/07/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

@interface Sound : SKNode
    -(AVAudioPlayer *)playSound : (NSString *)fName :(NSString *) ext;
    -(void)PLAY:(NSString *)Name :(NSString *)ext;
@end
