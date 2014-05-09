//
//  Utils.h
//  TesteEmptyProj
//
//  Created by Adriano Papa on 1/5/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <Foundation/Foundation.h>

#define tol 0.0001

@interface Vector : NSObject
{
    double x;
    double y;
    double z;
}

@property double x;
@property double y;
@property double z;

- (id)initWithUnitaryVector;
- (id)initWithZeros;
- (id)initWithX:(double)xi Y:(double)yi Z:(double)zi;
- (double)Magnitude;
- (void)Normalize;
- (void)Reverse;
- (void)Add:(Vector*)v;
- (void)Sub:(Vector*)v;
- (void)Mul:(double)s;
- (void)Div:(double)s;

+ (Vector*)Add:(Vector*)u _v2:(Vector*)v;
+ (Vector*)Sub:(Vector*)u _v2:(Vector*)v;
+ (Vector*)Cross:(Vector*)u _v2:(Vector*)v;
+ (double)Dot:(Vector*)u _v2:(Vector*)v;
+ (Vector*)Mul:(Vector*)u scalar:(double)s;
+ (Vector*)Div:(Vector*)u scalar:(double)s;
+ (double)TScProd:(Vector*)u _v2:(Vector*)v _v3:(Vector*)w;

@end
