//
//  LostoClockAppDelegate.h
//  LostoClock
//
//  Created by BUDDAx2 on 21.03.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LostoClockViewController;

@interface LostoClockAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LostoClockViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LostoClockViewController *viewController;

@end

