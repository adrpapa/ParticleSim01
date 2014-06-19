//
//  Particle.m
//  ParticleSim01
//
//  Created by Adriano Papa on 5/8/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "Particle.h"

@implementation Particle

@synthesize vPosition,vVelocity,fMass,vImpactForces, vPreviousPosition;
@synthesize startPos, fRadius, bCollision;

- (id)initWithPosition:(CGPoint)pos
{
    self = [super init];
    
    if (self)
    {
        fMass = 1.0;
        
        vPosition = [[Vector alloc] initWithX:pos.x Y:pos.y Z:0.0];
        vVelocity = [[Vector alloc] initWithZeros];
        vForces = [[Vector alloc] initWithZeros];
        vPreviousPosition = [[Vector alloc] initWithZeros];
        vImpactForces = [[Vector alloc] initWithZeros];
        vGravity = [[Vector alloc] initWithX:0.0 Y:(fMass * _GRAVITYACCELERATION) Z:0.0];
        bCollision = false;
        
        fSpeed = 0.0;
        fRadius = 1.5;
    }
    
    return self;
}

- (void)initialize
{
    
}

- (void)calcLoads
{
    vForces.x = 0.0;
    vForces.y = 0.0;

    if (bCollision)
    {
        // Add impact forces
        [vForces Add:vImpactForces];
    }
    else
    {
        [vForces Add:vGravity];
        
        Vector *vDrag = [[Vector alloc] initWithZeros];
        float fDrag;

        [vDrag Sub:vVelocity];
        [vDrag Normalize];
        
        fDrag = 0.5 * _AIRDENSITY * fSpeed * fSpeed * (M_PI * fRadius * fRadius) * _DRAGCOEFFICIENT;
             
        [vDrag Mul:(double)fDrag];
        
        [vForces Add:vDrag];
        
        // Wind
        Vector *vWind = [[Vector alloc] initWithX:0.5 * _AIRDENSITY * _WINDSPEED * _WINDSPEED * (M_PI * fRadius * fRadius) * _DRAGCOEFFICIENT Y:0.0 Z:0.0];

        [vForces Add:vWind];
    }
}

- (void)updateBodyEuler:(double)dt
{
    Vector *a;
    Vector *dv;
    Vector *ds;
    
    a = [[Vector alloc] initWithZeros];
    dv = [[Vector alloc] initWithZeros];
    ds = [[Vector alloc] initWithZeros];
    
    vPreviousPosition.x = vPosition.x;
    vPreviousPosition.y = vPosition.y;
    vPreviousPosition.z = vPosition.z;
    
    // a = F / m
    a = [Vector Div:vForces scalar:(double)fMass];
    
    // dv = a dt
    dv = [Vector Mul:a scalar:dt];
    [vVelocity Add:dv];
    
    ds = [Vector Mul:vVelocity scalar:dt];
    [vPosition Add:ds];
    
    fSpeed = (float) [vVelocity Magnitude];
}

- (void)render
{
    
}

@end
