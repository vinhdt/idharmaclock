//
//  TimerSetUp.h
//  LostoClock
//
//  Created by BUDDAx2 on 26.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern int timerHour;
extern int timerMinute;
extern int timerSecond;

@interface TimerSetUp : UIViewController {
	IBOutlet UIDatePicker *dp;
}

- (IBAction)backToMain;
- (IBAction)goToTimer;
- (IBAction)getDate;
@end
