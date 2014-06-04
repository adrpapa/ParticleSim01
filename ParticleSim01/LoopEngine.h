//
//  LoopEngine.h
//  ParabMovSim
//
//  Created by Adriano Papa on 4/19/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticleSimView.h"
//#import "PhysicsEngine.h"

#define _TIMESTEP               0.1
#define _RENDER_FRAME_COUNT     10
#define _RESTITUTION            0.8
#define _GROUND_PLANE           200

@interface LoopEngine : NSObject <ParticleSimViewDelegate>
{
	ParticleSimView *mainView;
//	NSMutableDictionary *physicsEngineDict;
//    PhysicsEngine *physicsEngine;
    NSMutableDictionary *particleDict;
    NSThread *loopEngineThread;
    BOOL continueLoop;
}

@property(strong,nonatomic) ParticleSimView *mainView;

- (void)startLoopEngineThread;

@end
