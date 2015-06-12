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

@implementation Masks

+ (uint32_t) jack {
    return MASKS_JACK;
}

+ (uint32_t) ground {
    return MASKS_GROUND;
}

@end
