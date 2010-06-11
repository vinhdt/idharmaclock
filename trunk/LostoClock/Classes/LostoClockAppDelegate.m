//
//  LostoClockAppDelegate.m
//  LostoClock
//
//  Created by BUDDAx2 on 21.03.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LostoClockAppDelegate.h"
#import "LostoClockViewController.h"

@implementation LostoClockAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	sleep(2);
    application.idleTimerDisabled = YES;
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
