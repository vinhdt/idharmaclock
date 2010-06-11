//
//  LostoClockViewController.h
//  LostoClock
//
//  Created by BUDDAx2 on 21.03.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LostoClockViewController : UIViewController <UIActionSheetDelegate>{

	IBOutlet UIImageView *hoursFirst;
	IBOutlet UIImageView *hoursSecond;
	IBOutlet UIImageView *minutesFirst;
	IBOutlet UIImageView *minutesSecond;
	IBOutlet UIImageView *bg1;
	IBOutlet UIImageView *bg2;
	IBOutlet UIImageView *bg3;
	IBOutlet UIImageView *firstMinutebg1;
	IBOutlet UIImageView *firstMinutebg2;
	IBOutlet UIImageView *firstMinutebg3;

	IBOutlet UIImageView *secondHourbg1;
	IBOutlet UIImageView *secondHourbg2;
	IBOutlet UIImageView *secondHourbg3;
	IBOutlet UIImageView *firstHourbg1;
	IBOutlet UIImageView *firstHourbg2;
	IBOutlet UIImageView *firstHourbg3;
	
	IBOutlet UIButton *secondTest;
	IBOutlet UIButton *alarmOn;
	IBOutlet UILabel *secondsLabel;
	IBOutlet UILabel *alarmLabel;
	IBOutlet UILabel *timeAlarmLabel;
	IBOutlet UILabel *timerLabel;
	IBOutlet UIButton *alarmIco;
	IBOutlet UIButton *timerIco;
	
	IBOutlet UIImageView *whiteBg1;
	IBOutlet UIImageView *whiteBg2;
	IBOutlet UIImageView *blackBg1;
	IBOutlet UIImageView *blackBg2;
	IBOutlet UIView *cancelAlarmView;

	UITextField * nameField;
	
	NSMutableArray * butnz;
	
	NSTimer *timer;
	NSTimer *timer2;
	NSTimer *myTicker;
}

- (IBAction)viewAlarmWindow;
//- (void) showInputFieldForEnterCode;
- (void) showCancelAlarmView;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (int)fMinute;
- (int)sMinute;
- (int)fHour;
- (int)sHour;
- (IBAction)settings;
- (IBAction)timerShow;
- (void)showActivity;
- (void)playPreAlarm;
- (void)playAlarm;
- (void)stopPreAlarm;
- (void)stopAlarmSound;
- (IBAction)showSeconds;
- (void)stopAlarm;
- (void)initPlayer;
- (void) setMinuteInTimer;
- (void) flipFirstMinute;
- (void) flipFirstHour;
- (void) flipSecondHour;

@end

