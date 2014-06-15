//
//  Particle.h
//  ParticleSim01
//
//  Created by Adriano Papa on 5/8/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

#define _GRAVITYACCELERATION    9.8f
#define _AIRDENSITY             1.23
#define _DRAGCOEFFICIENT        0.006
#define _WINDSPEED              10.0

@interface Particle : NSObject
{
    float fMass;
    Vector *vPosition;
    Vector *vVelocity;
    float fSpeed;
    Vector *vForces;
    float fRadius;
    Vector *vGravity;
    CGPoint startPos;
    Vector *vPreviousPosition;
    Vector *vImpactForces;
    BOOL bCollision;
}

@property float fMass;
@property float fRadius;
@property (strong,nonatomic) Vector *vPosition;
@property (strong,nonatomic) Vector *vVelocity;
@property (strong,nonatomic) Vector *vImpactForces;
@property (strong,nonatomic) Vector *vPreviousPosition;
@property (nonatomic) BOOL bCollision;

@property (nonatomic) CGPoint startPos;

- (id)initWithPosition:(CGPoint)pos;
- (void)calcLoads;
- (void)updateBodyEuler:(double)dt;
- (void)render;

@end
