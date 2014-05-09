//
//  Utils.m
//  TesteEmptyProj
//
//  Created by Adriano Papa on 1/5/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import "Vector.h"

@implementation Vector

@synthesize x,y,z;

// Initializes a Vector Unitary
//
- (id)initWithUnitaryVector
{
    if ([self init])
    {
        x = y = z = 1.0;
    }
    
    return self;
}

// Initialize a Vector with Zeros
//
- (id)initWithZeros
{
    if ([self init])
    {
        x = y = z = 0.0;
    }
    
    return self;
}

// Initialize a Vector with x,y and z values
//
- (id)initWithX:(double)xi Y:(double)yi Z:(double)zi
{
    if ([self init])
    {
        x = xi;
        y = yi;
        z = zi;
    }
    
    return self;
}

// Calculates the length of the Vector
//
- (double)Magnitude
{
    return sqrt(x*x + y*y + z*z);
}

// Converts a Vector to an unitary Vector
//
- (void)Normalize
{
    double m = [self Magnitude];
    
    if ( m < tol ) m = 1;
    
    x /= m;
    y /= m;
    z /= m;
    
    if ( fabs(x) < tol ) x = 0.0f;
    if ( fabs(y) < tol ) y = 0.0f;
    if ( fabs(z) < tol ) z = 0.0f;
}

// Invert the vector director
//
- (void)Reverse
{
    x = -x;
    y = -y;
    z = -z;
}

// Add one vector to the current one
//
- (void)Add:(Vector*)v
{
    x += v.x;
    y += v.y;
    z += v.z;
}

// Subtract one vector to the current one
//
- (void)Sub:(Vector*)v
{
    x -= v.x;
    y -= v.y;
    z -= v.z;
}

// Multiply the current vector by one scalar
//
- (void)Mul:(double)s
{
    x *= s;
    y *= s;
    z *= s;
}

// Divide the current vector by one scalar
//
- (void)Div:(double)s
{
    if ( s == 0 ) return;
    
    x /= s;
    y /= s;
    z /= s;
}

// Add two vectors
//
+ (Vector*)Add:(Vector*)u _v2:(Vector*)v
{
    Vector *v2 = [[Vector alloc] initWithX:u.x+v.x Y:u.y+v.y Z:u.z+v.z];
                  
    return v2;
}

// Subtract two vectors
//
+ (Vector*)Sub:(Vector *)u _v2:(Vector *)v
{
    Vector *v2 = [[Vector alloc] initWithX:u.x-v.x Y:u.y-v.y Z:u.z-v.z];
    
    return v2;
}

// Vector Cross Product
//
+ (Vector*)Cross:(Vector*)u _v2:(Vector*)v
{
    double new_x = u.y*v.z - u.z*v.y;
    double new_y = -u.x*v.z + u.z*v.x;
    double new_z = u.x*v.y - u.y*v.x;
    
    Vector *v2 = [[Vector alloc] initWithX:new_x Y:new_y Z:new_z];
    
    return v2;
}

// Vector Dot Product
//
+ (double)Dot:(Vector*)u _v2:(Vector*)v
{
    return u.x*v.x + u.y*v.y + u.z*v.z;
}

// Multiply one vector by one scalar
//
+ (Vector*)Mul:(Vector*)u scalar:(double)s
{
    Vector *v2 = [[Vector alloc] initWithX:u.x*s Y:u.y*s Z:u.z*s];
    
    return v2;
}

// Divide one vector by one scalar
//
+ (Vector*)Div:(Vector*)u scalar:(double)s
{
    if (s == 0) return nil;
    
    Vector *v2 = [[Vector alloc] initWithX:u.x/s Y:u.y/s Z:u.z/s];
    
    return v2;
}

// Triple Scalar Product
//
+ (double)TScProd:(Vector*)u _v2:(Vector*)v _v3:(Vector*)w
{
    return ( u.x * (v.y*w.z - v.z*w.y) + ( u.y * (-v.x*w.z + v.z*w.x)) + ( u.z * (v.x*w.y - v.y*w.x)) );
}

@end
