//
//  PhysicsEngine.m
//  ParabMovSim
//
//  Created by Adriano Papa on 5/4/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "PhysicsEngine.h"

@implementation PhysicsEngine


- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}
/*
- (void)addEntity:(Entity*)_entity withKey:(NSString*)key
{
	[entityDict setValue:_entity forKey:key];
}

- (void)removeEntity:(NSString*)key
{
	[entityDict removeObjectForKey:key];
}
*/

- (void)update
{
    double dt = _TIMESTEP;
    
	[particleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Particle *unit = (Particle*)obj;
        
        // update the particles (Units)
        [unit calcLoads];
        [unit updateBodyEuler:dt];
        
        if (frameCounter >= _RENDER_FRAME_COUNT)
        {
            [unit render];
        }
	}];
    
    if (frameCounter >= _RENDER_FRAME_COUNT)
    {
        frameCounter = 0;
    }
    else
    {
        frameCounter++;
    }
}

@end
