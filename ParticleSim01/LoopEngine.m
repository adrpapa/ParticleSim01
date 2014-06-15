//
//  LoopEngine.m
//  AppleCatcher
//
//  Created by Adriano Papa on 3/24/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "LoopEngine.h"

@implementation LoopEngine

@synthesize mainView;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        particleDict = [NSMutableDictionary dictionaryWithCapacity:MAX_UNITS];
        obstacleArray = [NSMutableArray arrayWithCapacity:MAX_OBSTACLES];
    }
    
    return self;
}

- (void)waitForThreadToFinish
{
    while (loopEngineThread && ![loopEngineThread isFinished]) { // Wait for the thread to finish.
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)startLoopEngineThread
{
    if (loopEngineThread != nil)
    {
        [loopEngineThread cancel];
        [self waitForThreadToFinish];
    }
    
	NSThread *thr = [[NSThread alloc] initWithTarget:self selector:@selector(loopEngine) object:nil];
	self->loopEngineThread = thr;
    
	[self->loopEngineThread start];
}

- (void)loopEngine
{
    [NSThread setThreadPriority:1.0];
    continueLoop = true;
	
	while (continueLoop) 
	{
        [NSThread sleepForTimeInterval:TIME_UNIT];
        
        // Call Update()
        [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}

- (void)stopSimulator
{
    continueLoop=false;
    [loopEngineThread cancel];
    [self waitForThreadToFinish];
    loopEngineThread=nil;
}

#pragma mark -
#pragma mark === Delegates Implementation ===
#pragma mark -

- (void)addEntity:(Particle*)_particle withKey:(NSString*)key
{
	[particleDict setValue:_particle forKey:key];
}

- (void)addEntity:(Particle*)_particle
{
    [obstacleArray addObject:_particle];
}

- (void)removeEntity:(NSString*)key
{
	[particleDict removeObjectForKey:key];
}

- (void)stop
{
    [self stopSimulator];
}

- (void)start
{
    [self startLoopEngineThread];
}

// ********** End Delegate Implementation ***********

- (BOOL)checkForCollisions:(Particle *)p
{
    Vector *n = [[Vector alloc] initWithZeros];
    Vector *vr = [[Vector alloc] initWithZeros];
    float vrn;          // Velocidade relativa normal
    float J;            // Impulso resultante da colisão
    Vector *Fi = [[Vector alloc] initWithZeros];    // Força de impacto derivada do impulso J
    BOOL hasCollision = false;
    
    Vector *v = p.vPosition;
    
    p.vImpactForces.x = 0.0;
    p.vImpactForces.y = 0.0;
    
    if (v.y > (_GROUND_PLANE+p.fRadius))
    {
        n.x = 0;
        n.y = -1;
        vr = p.vVelocity;
        vrn = (double) [Vector Dot:vr _v2:n];
        
        if (vrn < 0.0)
        {
            // vrn = [v1a - v2a] * n
            // v1a = v * n
            // e = -(v1d - v2d) / (v1a - v2a)
            // I = F dt = m(vd - va)
            // F = I/dt
            // IMPULSO = -vrn * e+1 * mass = -(v * n) * e+1 * mass;
            // Fi = n x (IMPULSO / dt)
            // F = ma => F = m dv/dt
            J = -([Vector Dot:vr _v2:n]) * (_RESTITUTION+1) * p.fMass;
            Fi.x = n.x;
            Fi.y = n.y;
            // x=0  y=-1  =>   Fi.x = 0   Fi.y = Fi.y * -1
            [Fi Mul:J/_TIMESTEP];
            [p.vImpactForces Add:Fi];
            
            p.vPosition.y = _GROUND_PLANE - p.fRadius;
            
            // x = p.vPosition.x
            // x0 = p.vPosition.y
            // x1 = p.vPreviousPosition.y
            // f(x0) = prevPos.y
            // f(x1) =
            // p(x) = f(x0) + [f(x1) - f(x0)]/x1-x0 * (x-x0)
            p.vPosition.x = (_GROUND_PLANE - p.fRadius - p.vPreviousPosition.y) / (p.vPosition.y - p.vPreviousPosition.y) * (p.vPosition.x - p.vPreviousPosition.x) + p.vPreviousPosition.x;
            
            hasCollision = true;
        }
    }
    
//    [obstacleArray  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    for (int idx=0; idx < obstacleArray.count; idx++)
    {
        Particle *obstacle = (Particle*)[obstacleArray objectAtIndex:idx];

        float r;
        Vector *d = [[Vector alloc] initWithZeros];
        float s;
//        Vector *n = [[Vector alloc] initWithZeros];
//        Vector *vr = [[Vector alloc] initWithZeros];
//        float vrn;
//        float J;
//        Vector *Fi = [[Vector alloc] initWithZeros];
        
        r = p.fRadius + obstacle.fRadius;
        d = [Vector Sub:p.vPosition _v2:obstacle.vPosition];
        s = [d Magnitude] - r;
        
        if (s <= 0.0)
        {
            [d Normalize];
            n = d;
            vr = [Vector Sub:p.vVelocity _v2:obstacle.vVelocity];
            vrn = [Vector Dot:vr _v2:n];
            
            if (vrn < 0.0)
            {
                J = -(vrn) * (_RESTITUTION_O+1) / (1/p.fMass + 1/obstacle.fMass);
                Fi.x = n.x;
                Fi.y = n.y;
                [Fi Mul:J/_TIMESTEP];
                [p.vImpactForces Add:Fi];
                
                [p.vPosition Sub:[Vector Mul:n scalar:s]];
                
                hasCollision = true;
            }
        }
    }
//    }];

    return hasCollision;
}

- (void)update
{
    [particleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Particle *particle = (Particle*) obj;
        
        particle.bCollision = [self checkForCollisions:particle];
        [particle calcLoads];
        [particle updateBodyEuler:_TIMESTEP];
    }];
    
    // Render on the view
    [self render];
}

- (void)render
{
	[particleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		Particle *particle = (Particle*) obj;

//    [mainView updateViewWithKey:key withPoint:CGPointMake(particle.vPosition.x + particle.startPos.x, particle.vPosition.y + particle.startPos.y)];
     
    [mainView updateViewWithKey:key withPoint:CGPointMake(particle.vPosition.x, particle.vPosition.y)];
    }];
}

@end
