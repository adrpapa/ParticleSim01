//
//  PhysicsEngine.h
//  ParabMovSim
//
//  Created by Adriano Papa on 5/4/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Particle.h"

#define _TIMESTEP               0.1
#define _RENDER_FRAME_COUNT     10

@interface PhysicsEngine : NSObject
{
    NSMutableArray *particleArray;
    NSInteger frameCounter;
}

- (void)update;

@end
