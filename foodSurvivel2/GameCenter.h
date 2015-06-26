//
//  GameCenter.h
//  JumpJack
//
//  Created by Eduarda Pinheiro on 26/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>



@interface GameCenter : NSObject

-(void) authenticateLocalPlayer;
extern NSString *const PresentAuthenticationViewController;

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+(instancetype)sharedGameCenter;



@end

