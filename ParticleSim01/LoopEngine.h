//
//  LoopEngine.h
//  ParabMovSim
//
//  Created by Adriano Papa on 4/19/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticleSimView.h"

#define _TIMESTEP               0.1
#define _RENDER_FRAME_COUNT     10
#define _RESTITUTION            0.8
#define _RESTITUTION_O          0.8
#define _GROUND_PLANE           300
#define TIME_UNIT				0.04


@interface LoopEngine : NSObject <ParticleSimViewDelegate>
{
	ParticleSimView *mainView;
    NSMutableDictionary *particleDict;
    NSMutableArray *obstacleArray;
    NSThread *loopEngineThread;
    BOOL continueLoop;
}

@property(strong,nonatomic) ParticleSimView *mainView;

- (void)startLoopEngineThread;

@end
