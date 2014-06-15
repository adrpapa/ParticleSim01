//
//  ParticleSimView.m
//  ParticleSim01
//
//  Created by Adriano Papa on 5/10/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "ParticleSimView.h"

@implementation ParticleSimView

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

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
            
            CGPoint _startPos = CGPointMake(_x, _y);
            
            particleView.layer.position = _startPos;
            
            [particleViewDict setValue:particleView forKey:key];
            
            Particle *particle = [[Particle alloc] initWithPosition:_startPos];
            particle.startPos = _startPos;
            
            [delegate addEntity:particle withKey:key];
            
            [self addSubview:particleView];
        }

        started = false;
    }
    return self;
}

- (void)drawCircle:(CGContextRef)context inPos:(CGPoint)centro
{
        // Drawing with a white stroke color
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        // And draw with a blue fill color
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 1.0);

        // Fill rect convenience equivalent to AddEllipseInRect(); FillPath();
   //     CGContextFillEllipseInRect(context, circleRect);
    CGContextAddArc(context, centro.x, centro.y, 10.0, DegreesToRadians(0), DegreesToRadians(360), 0);
        // Close the path
        CGContextClosePath(context);
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFillStroke);
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (int j=0; j < MAX_OBSTACLES; j++)
    {
        NSUInteger _x = arc4random_uniform(self.frame.size.width-_OBSTACLE_RADIUS*2);
        if (_x < _OBSTACLE_RADIUS) _x = _OBSTACLE_RADIUS;
        NSUInteger _y = arc4random_uniform(_GROUND_PLANE-_OBSTACLE_RADIUS);
        if (_y < 150) _y += 150;
        
        Particle *obstacle = [[Particle alloc] initWithPosition:CGPointMake(_x, _y)];
        obstacle.fMass = 10;
        obstacle.fRadius = _OBSTACLE_RADIUS;
        
        [delegate addEntity:obstacle];
        
 //       CGRect circleRect = CGRectMake(_x, _y, _OBSTACLE_RADIUS*2, _OBSTACLE_RADIUS*2);
        
        [self drawCircle:context inPos:CGPointMake(_x, _y)];
    }
}


@end
