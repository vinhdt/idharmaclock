//
//  AlarmSettings.h
//  LostoClock
//
//  Created by BUDDAx2 on 22.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

extern BOOL isAlarm;
extern int alarmHour;
extern int alarmMinute;
extern int alarmCountDown;

	AVAudioPlayer *player;
	AVAudioPlayer *player2;

@interface AlarmSettings : UIViewController {
	IBOutlet UILabel *time;
	IBOutlet UIDatePicker *dp;
	IBOutlet UISwitch *setAlarm;
}

- (IBAction)backToMain;
- (IBAction)getDate;
- (IBAction)setAlarmSwitch;
@end
