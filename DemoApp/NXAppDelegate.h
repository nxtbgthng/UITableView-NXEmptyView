//
//  NXAppDelegate.h
//  DemoApp
//
//  Created by Ullrich Schäfer on 21.06.12.
//  Copyright (c) 2012 nxtbgthng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXViewController;

@interface NXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NXViewController *viewController;

@end
