//
//  LoopEngine.m
//  AppleCatcher
//
//  Created by Adriano Papa on 3/24/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "LoopEngine.h"

#define TIME_UNIT					0.04
#define MAX_OBJS                    5

@implementation LoopEngine

@synthesize mainView;

- (id)init
{
    self = [super init];
    
    if (self)
    {
//		physicsEngineDict = [NSMutableDictionary dictionaryWithCapacity:MAX_OBJS];
//        physicsEngine = [[PhysicsEngine alloc] init];
        particleDict = [NSMutableDictionary dictionaryWithCapacity:MAX_UNITS];
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

- (void)checkForCollisions:(Particle *)p
{
    Vector *n = [[Vector alloc] initWithZeros];
    Vector *vr = [[Vector alloc] initWithZeros];
    float vrn;
    float J;
    Vector *Fi = [[Vector alloc] initWithZeros];
    BOOL hasCollision = false;
    
    Vector *v = p.vPosition;
    
    if (v.y > (mainView.frame.size.height+p.fRadius))
    {
        n.x = 0;
        n.y = 1;
        vr = p.vVelocity;
        vrn = (double) [Vector Dot:vr _v2:n];
        
        if (vrn < 0.0)
        {
            J = -([Vector Dot:vr _v2:n]) * (_RESTITUTION+1) * p.fMass;
            Fi = n;
            [Fi Mul:J/_TIMESTEP];
            [p.vImpactForces Add:Fi];
        }
    }

}

- (void)update
{
    [particleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Particle *particle = (Particle*) obj;
        
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

	    [mainView updateViewWithKey:key withPoint:CGPointMake(particle.vPosition.x + particle.startPos.x, mainView.frame.size.height - (particle.vPosition.y + particle.startPos.y))];
    }];
}

@end
