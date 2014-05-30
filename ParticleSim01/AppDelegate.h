//
//  AppDelegate.h
//  ParticleSim01
//
//  Created by Adriano Papa on 5/8/14.
//  Copyright (c) 2014 Adriano Papa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticleSimControllerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    ParticleSimControllerViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ParticleSimControllerViewController *viewController;

@end
