//
//  Masks.m
//  foodSurvivel2
//
//  Created by Kevin Oliveira on 11/06/15.
//  Copyright © 2015 edu FUCAPI. All rights reserved.
//

#import "Masks.h"

#define MASKS_JACK      1
#define MASKS_GROUND    2
#define MASKS_REDBALL   3
#define MASKS_GREENBALL 4
#define MASKS_BOX       5

@implementation Masks

+ (uint32_t) jack {
    return MASKS_JACK;
}

+ (uint32_t) ground {
    return MASKS_GROUND;
}

+ (uint32_t) redBall {
    return MASKS_REDBALL;
}

+ (uint32_t) greenBall {
    return MASKS_GREENBALL;
}

+ (uint32_t) box {
    return MASKS_BOX;
}

@end
