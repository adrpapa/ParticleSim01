//
//  Particle.h
//  ParticleSim01
//
//  Created by Adriano Papa on 5/8/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@interface Particle : NSObject
{
    float fMass;
    Vector *vPosition;
    Vector *vVelocity;
    float fSpeed;
    Vector *vForces;
    float fRadius;
    Vector *vGravity;
}

- (void)updateBodyEuler:(double)dt;
- (void)render;

@end
