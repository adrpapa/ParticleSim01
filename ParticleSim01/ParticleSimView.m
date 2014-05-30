//
//  ParticleSimView.m
//  ParticleSim01
//
//  Created by Adriano Papa on 5/10/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "ParticleSimView.h"

@implementation ParticleSimView

@synthesize delegate;

- (id)initWithDelegate:(id <ParticleSimViewDelegate>)_delegate andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        particleViewDict = [NSMutableDictionary dictionaryWithCapacity:MAX_UNITS];
        delegate = _delegate;
        
        for (int i=0; i < MAX_UNITS; i++)
        {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            UIImageView *particleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particle.png"]];
            
            NSUInteger _x = arc4random_uniform(self.frame.size.width);
            NSUInteger _y = arc4random_uniform(self.frame.size.height/5);
            
            CGPoint _startPos = CGPointMake(_x, self.frame.size.height - _y);
            
            particleView.layer.position = _startPos;
            
            [particleViewDict setValue:particleView forKey:key];
            
            Particle *particle = [[Particle alloc] init];
            particle.startPos = _startPos;
            
            [delegate addEntity:particle withKey:key];
            
            [self addSubview:particleView];
        }
        
        started = false;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (started)
    {
        started = false;
        [delegate stop];
    }
    else
    {
        [delegate start];
        started = true;
    }
}

- (void)updateViewWithKey:(NSString*)key withPoint:(CGPoint)pos
{
    UIImageView *particleView = (UIImageView*) [particleViewDict objectForKey:key];
    
    if ((particleView.layer.position.y > self.bounds.size.height || particleView.layer.position.x > self.bounds.size.width || particleView.layer.position.x < 0 || particleView.layer.position.y < 0) )
    {
        [particleView removeFromSuperview];
    }
    else
    {
        particleView.layer.position = pos;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
