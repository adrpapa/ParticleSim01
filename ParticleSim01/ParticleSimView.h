//
//  ParticleSimView.h
//  ParticleSim01
//
//  Created by Adriano Papa on 5/10/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Particle.h"

#define MAX_UNITS       200

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
- (void)removeEntity:(NSString*)key;
- (void)stop;
- (void)start;

@end