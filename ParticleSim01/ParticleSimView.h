//
//  ParticleSimView.h
//  ParticleSim01
//
//  Created by Adriano Papa on 5/10/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Particle.h"

#define MAX_UNITS           1
#define MAX_OBSTACLES       20
#define _GROUND_PLANE       300
#define _OBSTACLE_RADIUS    10

@protocol ParticleSimViewDelegate;

@interface ParticleSimView : UIView
{
    BOOL started;
    NSMutableDictionary *particleViewDict;
    id <ParticleSimViewDelegate> delegate;
}

@property(strong,nonatomic) id <ParticleSimViewDelegate> delegate;

- (void)updateViewWithKey:(NSString*)key withPoint:(CGPoint)pos;
- (id)initWithDelegate:(id <ParticleSimViewDelegate>)_delegate andFrame:(CGRect)frame;

@end

@protocol ParticleSimViewDelegate

- (void)addEntity:(Particle*)_particle withKey:(NSString*)key;
- (void)addEntity:(Particle*)_particle;
- (void)removeEntity:(NSString*)key;
- (void)stop;
- (void)start;

@end