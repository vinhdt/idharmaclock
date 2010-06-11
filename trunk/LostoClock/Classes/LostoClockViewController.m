//
//  LostoClockViewController.m
//  LostoClock
//
//  Created by BUDDAx2 on 21.03.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import "LostoClockViewController.h"
#import "AlarmSettings.h"
#import "TimerSetUp.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

BOOL isAlarm;
int alarmHour;
int alarmMinute;
int alarmCountDown = 0;

static int i = 1;
static int steps = 7;
static float stepz = 0.33;
static int numbers = 13;
static int firstHour = 13;
static int firstminutez = 13;
static int secondHour;
static float speed = 0.02;
static BOOL newTime;
static BOOL isFirstMinuteFlipEnded;
static BOOL isFirstHourFlipEnded;
static BOOL isSecondHourFlipEnded;
static BOOL redColorTurnOn;
//static int alarmAnswer;
static int trueChoiceAlarmOff;

@implementation LostoClockViewController

- (IBAction)settings{
	if ([player isPlaying] || [player isPlaying]) {
		[self viewAlarmWindow];
	}
	else {		
		AlarmSettings * settingsView = [[AlarmSettings alloc] initWithNibName:nil bundle:nil];
		[self presentModalViewController:settingsView animated:NO];
		[LostoClockViewController release];
		[myTicker invalidate];
		[settingsView release];
	}
}
- (IBAction)timerShow{
	if ([player isPlaying] || [player isPlaying]) {
		[self viewAlarmWindow];
	}
	else {
		TimerSetUp * timerView = [[TimerSetUp alloc] initWithNibName:nil bundle:nil];
		[self presentModalViewController:timerView animated:NO];
		[LostoClockViewController release];
		[myTicker invalidate];
		[timerView release];
	}
}

- (void)showSeconds{	
	if (secondsLabel.hidden) {
		secondsLabel.hidden = NO;
	}
	else {
		secondsLabel.hidden = YES;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (secondTest.hidden) {
//		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];	
//		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
		secondTest.hidden = NO;
		timerIco.hidden = NO;
		timerLabel.hidden = NO;		
		alarmIco.hidden = NO;
		alarmLabel.hidden = NO;
		if (isAlarm) {
			alarmOn.hidden = NO;
			timeAlarmLabel.text = [NSString stringWithFormat:@"%02d:%02d", alarmHour, alarmMinute];
			timeAlarmLabel.hidden = NO;
		}
		else {
			alarmOn.hidden = YES;
			timeAlarmLabel.hidden = YES;
		}

	}
	else {
//		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		alarmOn.hidden = YES;
		timeAlarmLabel.hidden = YES;
		secondTest.hidden = YES;
		timerIco.hidden = YES;
		timerLabel.hidden = YES;		
		alarmIco.hidden = YES;
		alarmLabel.hidden = YES;
	}
}

- (void)playPreAlarm{
	[player play];
}
- (void)playAlarm{
	[player2 play];
}

- (void)stopPreAlarm{
	if (player) {
		[player stop];
	}
}
- (void)stopAlarmSound{
	[player2 stop];
}

-(int)sMinute {
	static NSString *minute;
	NSDateFormatter *mTimeFormat = [[NSDateFormatter alloc] init];
	[mTimeFormat setDateFormat:@"mm"];
	NSDate *now = [[NSDate alloc] init];
	NSString *mTime = [mTimeFormat stringFromDate:now];
	minute = [mTime substringWithRange:NSMakeRange(1, 1)];
	return [minute integerValue];
	
	[now release];
	[minute release];
	[mTime release];
	[mTimeFormat release];
}
-(int)fMinute {
	static NSString *minute;
	NSDateFormatter *mTimeFormat = [[NSDateFormatter alloc] init];
	[mTimeFormat setDateFormat:@"mm"];
	NSDate *now = [[NSDate alloc] init];
	NSString *mTime = [mTimeFormat stringFromDate:now];
	minute = [mTime substringWithRange:NSMakeRange(0, 1)];
	
	return [minute integerValue];
	
	[now release];
	[minute release];
	[mTime release];
	[mTimeFormat release];
}

-(int)sHour {
	static NSString *minute;
	NSDateFormatter *mTimeFormat = [[NSDateFormatter alloc] init];
	[mTimeFormat setDateFormat:@"HH"];
	NSDate *now = [[NSDate alloc] init];
	NSString *mTime = [mTimeFormat stringFromDate:now];
	minute = [mTime substringWithRange:NSMakeRange(1, 1)];
	return [minute integerValue];
	
	[now release];
	[minute release];
	[mTime release];
	[mTimeFormat release];
}
-(int)fHour {
	static NSString *minute;
	NSDateFormatter *mTimeFormat = [[NSDateFormatter alloc] init];
	[mTimeFormat setDateFormat:@"HH"];
	NSDate *now = [[NSDate alloc] init];
	NSString *mTime = [mTimeFormat stringFromDate:now];
	minute = [mTime substringWithRange:NSMakeRange(0, 1)];
	
	return [minute integerValue];
	
	[now release];
	[minute release];
	[mTime release];
	[mTimeFormat release];
}

// Вторая табличка минут.
-(void) setMinuteInTimer{
	NSString *tableColor = @"w";
	numbers = [self sMinute];
	
	if (redColorTurnOn) {
		tableColor = @"ir";
	}
	
	int prevNumber;
	prevNumber = numbers;
	if (prevNumber == -1) {
		prevNumber = 9;
	}
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,numbers];
	bg1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,prevNumber];
	bg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
	
	float scaleCoef = 1 - (stepz * i);
	bg1.hidden = NO;
	
	
	if (scaleCoef >= 0) {
		bg2.transform = CGAffineTransformConcat(
												bg2.transform = CGAffineTransformMakeScale(1, scaleCoef),
												CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																				 bg2.frame.size.height  / 2  + 53));
	}
	if (scaleCoef < 0) {
		if (i == steps) {
			scaleCoef = -1;
		}
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down",tableColor,prevNumber];
		bg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin ofType:@"png"]];
		bg2.transform = CGAffineTransformConcat(
												bg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
												CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																				 bg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		[timer invalidate];
		
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down",tableColor,numbers];
		bg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin3 ofType:@"png"]];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up",tableColor,numbers];
		bg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin2 ofType:@"png"]];
		
		bg1.hidden = YES;
		bg2.transform = CGAffineTransformMakeScale(1, 1);
		
		if (numbers == 0 && !isFirstMinuteFlipEnded && !newTime) {
			isFirstMinuteFlipEnded = YES;
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(flipFirstMinute) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
		if (numbers != 0) {
			isFirstMinuteFlipEnded = NO;
		}
		if (newTime == YES) {
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(flipFirstMinute) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
	}
}
// Первая табличка минут.
-(void) flipFirstMinute{
	firstminutez = [self fMinute];
	
	NSString *tableColor = @"w";
	if (redColorTurnOn) {
		tableColor = @"ir";
	}

	//NSLog(@"firstminutez");
	int prevNumber = firstminutez;
	if (prevNumber == -1) {
		prevNumber = 9;
	}
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,firstminutez];
	firstMinutebg1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,prevNumber];
	firstMinutebg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];	
	
	float scaleCoef = 1 - (stepz * i);
	firstMinutebg1.hidden = NO;
	
	
	if (scaleCoef >= 0) {
		firstMinutebg2.transform = CGAffineTransformConcat(
												firstMinutebg2.transform = CGAffineTransformMakeScale(1, scaleCoef),
												CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																				 firstMinutebg2.frame.size.height  / 2  + 53));
	}
	if (scaleCoef < 0) {
		if (i == steps) {
			scaleCoef = -1;
		}
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down",tableColor,prevNumber];
		firstMinutebg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin ofType:@"png"]];
		firstMinutebg2.transform = CGAffineTransformConcat(
												firstMinutebg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
												CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																				 firstMinutebg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		[timer invalidate];
		
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down",tableColor,firstminutez];
		firstMinutebg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin3 ofType:@"png"]];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up",tableColor,firstminutez];
		firstMinutebg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin2 ofType:@"png"]];
		
		firstMinutebg1.hidden = YES;
		firstMinutebg2.transform = CGAffineTransformMakeScale(1, 1);

		//NSLog(@"fHour:%d \n sHour:%d \n fMinute:%d \n sMinute:%d",firstHour, secondHour, firstminutez, numbers);
		
		if (firstminutez == 0 && numbers == 0 && !isSecondHourFlipEnded && !newTime) {
			isSecondHourFlipEnded = YES;
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(flipSecondHour) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
		if (firstminutez != 0) {
			isSecondHourFlipEnded = NO;
		}
//		if (!secondHour) {
		if (newTime == YES) {
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(flipSecondHour) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
		
	}
}
// Вторая табличка часа.
-(void) flipSecondHour{
	secondHour = [self sHour];
	int prevNumber = secondHour;
	if (prevNumber == -1) {
		prevNumber = 9;
	}
	
	NSString *tableColor = @"b";
	if (redColorTurnOn) {
		tableColor = @"ib";
	}
	
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,secondHour];
	secondHourbg1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,prevNumber];
	secondHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];	
	
	float scaleCoef = 1 - (stepz * i);
	secondHourbg1.hidden = NO;
	
	
	if (scaleCoef >= 0) {
		secondHourbg2.transform = CGAffineTransformConcat(
														   secondHourbg2.transform = CGAffineTransformMakeScale(1, scaleCoef),
														   CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																							secondHourbg2.frame.size.height  / 2  + 53));
	}
	if (scaleCoef < 0) {
		if (i == steps) {
			scaleCoef = -1;
		}
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down",tableColor,prevNumber];
		secondHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin ofType:@"png"]];
		secondHourbg2.transform = CGAffineTransformConcat(
														   secondHourbg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
														   CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																							secondHourbg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		[timer invalidate];

		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down",tableColor,secondHour];
		secondHourbg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin3 ofType:@"png"]];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up",tableColor,secondHour];
		secondHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin2 ofType:@"png"]];
		
		secondHourbg1.hidden = YES;
		secondHourbg2.transform = CGAffineTransformMakeScale(1, 1);
		
		if (secondHour == 0 && firstminutez == 0 && numbers == 0 && !isFirstHourFlipEnded && !newTime) {
			isFirstHourFlipEnded = YES;
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(flipFirstHour) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
		if (secondHour != 0) {
			isFirstHourFlipEnded = NO;
		}

//		if (firstHour == 13) {
		if (newTime == YES) {
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(flipFirstHour) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		}
		
	}
}
// Первая табличка часа.
-(void) flipFirstHour{
	firstHour = [self fHour];
	int prevNumber = firstHour;
	if (prevNumber == -1) {
		prevNumber = 9;
	}

	NSString *tableColor = @"b";
	if (redColorTurnOn) {
		tableColor = @"ib";
	}
	
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,firstHour];
	firstHourbg1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,prevNumber];
	firstHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];	
	
	float scaleCoef = 1 - (stepz * i);
	firstHourbg1.hidden = NO;
	
	
	if (scaleCoef >= 0) {
		firstHourbg2.transform = CGAffineTransformConcat(
														  firstHourbg2.transform = CGAffineTransformMakeScale(1, scaleCoef),
														  CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																						   firstHourbg2.frame.size.height  / 2  + 53));
	}
	if (scaleCoef < 0) {
		if (i == steps) {
			scaleCoef = -1;
		}
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down",tableColor,prevNumber];
		firstHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin ofType:@"png"]];
		firstHourbg2.transform = CGAffineTransformConcat(
														  firstHourbg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
														  CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																						   firstHourbg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		//NSLog(@"переворот 4 пластинки");
		
		[timer invalidate];
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down",tableColor,firstHour];
		firstHourbg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin3 ofType:@"png"]];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up",tableColor,firstHour];
		firstHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin2 ofType:@"png"]];
		
		firstHourbg1.hidden = YES;
		firstHourbg2.transform = CGAffineTransformMakeScale(1, 1);
		if (newTime == YES) {
			newTime = NO;
		}
		
		if (!myTicker) {
			//NSLog(@"start myTicker");
			myTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];
		}	
	}
}

- (void)showActivity{
			
	if (blackBg1.hidden) {
		blackBg1.hidden = NO;
	}
	if (blackBg2.hidden) {
		blackBg2.hidden = NO;
	}
	
	NSDateFormatter *hTimeFormat = [[NSDateFormatter alloc] init];
	[hTimeFormat setDateFormat:@"HH"];
	NSDateFormatter *mTimeFormat = [[NSDateFormatter alloc] init];
	[mTimeFormat setDateFormat:@"mm"];
	NSDateFormatter *sTimeFormat = [[NSDateFormatter alloc] init];
	[sTimeFormat setDateFormat:@"ss"];
	
	NSDate *now = [[NSDate alloc] init];
	
	NSString *hTime = [hTimeFormat stringFromDate:now];
	NSString *mTime = [mTimeFormat stringFromDate:now];
	NSString *sTime = [sTimeFormat stringFromDate:now];

	
	if ([sTime isEqualToString:@"00"]) {
		timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setMinuteInTimer) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
	
	if (isAlarm)
	{
		bool needsAlarm = (alarmHour == [hTime integerValue] && (alarmMinute - 1) == [mTime integerValue] && [sTime isEqualToString:@"00"]);
		bool needsAlarm2 = (alarmHour == [hTime integerValue] && (alarmMinute - 1) == [mTime integerValue]);

		if (needsAlarm){
			[self initPlayer];
			[self playPreAlarm];
		}
		if (needsAlarm2){
//			[self showRedBG];
		}
	}

	if (isAlarm)
	{
		bool needsAlarm2 = (alarmHour == [hTime integerValue] && (alarmMinute - 1) == [mTime integerValue] && [sTime isEqualToString:@"50"]);
		if (needsAlarm2){
			newTime = YES;
			redColorTurnOn = YES;
			timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setMinuteInTimer) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];		
			
			NSString *bgrnd = [NSString stringWithFormat:@"redBgrnd.png"];
			whiteBg1.image = [UIImage imageNamed:bgrnd];
			whiteBg2.image = [UIImage imageNamed:bgrnd];

			[player stop];
			[self playAlarm];
		}
	}
		
	secondsLabel.text = sTime;
	
	[now release];
	[hTimeFormat release];
	[mTimeFormat release];
	[sTimeFormat release];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSString *tableColor = @"w";
	numbers = [self sMinute];
	firstminutez = [self fMinute];
	secondHour = [self sHour];
	firstHour = [self fHour];
	
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,numbers];
	bg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	secMin1 = [NSString stringWithFormat:@"%@-%d-down",tableColor,numbers];
	bg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];

	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,firstminutez];
	firstMinutebg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	secMin1 = [NSString stringWithFormat:@"%@-%d-down",tableColor,firstminutez];
	firstMinutebg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];

	tableColor = @"b";

	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,secondHour];
	secondHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	secMin1 = [NSString stringWithFormat:@"%@-%d-down",tableColor,secondHour];
	secondHourbg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up",tableColor,firstHour];
	firstHourbg2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	secMin1 = [NSString stringWithFormat:@"%@-%d-down",tableColor,firstHour];
	firstHourbg3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:secMin1 ofType:@"png"]];
	
//	newTime = YES;
//				  
//	timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setMinuteInTimer) userInfo:nil repeats:YES];
//	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	if (!myTicker) {
		myTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showActivity) userInfo:nil repeats:YES];
	}		
}

- (void)initPlayer{
	if (![player isPlaying]) {
		NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
		resourcePath = [resourcePath stringByAppendingString:@"/preAlarm2.mp3"];
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath] error:nil];
		player.numberOfLoops = -1;
		[player prepareToPlay];
		
		NSString* resourcePath2 = [[NSBundle mainBundle] resourcePath];
		resourcePath2 = [resourcePath2 stringByAppendingString:@"/alarm1.mp3"];
		player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath2] error:nil];
		player2.numberOfLoops = -1;
		[player2 prepareToPlay];
	}	
}

- (void) showCancelAlarmView{

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == trueChoiceAlarmOff) {
		[self stopAlarm];
	}
	else {
		[self viewAlarmWindow];
	}
}
- (IBAction)viewAlarmWindow{
	butnz = [NSMutableArray arrayWithObjects:@"4 16 8 15 42 23",@"4 8 15 16 23 42",@"42 23 15 16 4 8",nil];
	
	for (NSInteger i = [butnz count] - 1; i > 0; --i) {
		[butnz exchangeObjectAtIndex: random() % (i + 1)
				  withObjectAtIndex: i]; 
	}
	
	NSString *btn1 = [butnz objectAtIndex:0];
	NSString *btn2 = [butnz objectAtIndex:1];
	NSString *btn3 = [butnz objectAtIndex:2];
	
	trueChoiceAlarmOff = [butnz indexOfObject:@"4 8 15 16 23 42"];

//	UIAlertView* simpleAlert = [[UIAlertView alloc] init];
//	[simpleAlert setDelegate:self];
//	[simpleAlert setTitle:@"Выбери правильные числа"];
//	[simpleAlert setMessage:@"4 8 15 16 23 42"];
//	[simpleAlert addButtonWithTitle:btn1];
//	[simpleAlert addButtonWithTitle:btn2];
//	[simpleAlert addButtonWithTitle:btn3];
//
////	UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Выбери правильные числа" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:btn1,btn2,btn3,nil];
//	[simpleAlert show];
//	[simpleAlert release];	
	

	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Choose the correct sequence of numbers \n 4 8 15 16 23 42" 
													  delegate:self
											 cancelButtonTitle:nil
										destructiveButtonTitle:nil
											 otherButtonTitles:btn1,btn2,btn3,nil];
	
    // Add the picker
//	[menu setAlpha:0.5];
    [menu showInView:self.view];        
    [menu release];	
}

- (void)stopAlarm{
//	[self showInputFieldForEnterCode];
			
	isAlarm = NO;
	[self stopPreAlarm];
	[self stopAlarmSound];
	alarmOn.hidden = YES;
	timeAlarmLabel.hidden = YES;
	numbers = 13;
	firstHour = 13;
	firstminutez = 13;
	secondHour = 13;
	
	if (redColorTurnOn) {
		newTime = YES;
		redColorTurnOn = NO;
		NSString *bgrnd = [NSString stringWithFormat:@"whiteBgrnd.png"];
		whiteBg1.image = [UIImage imageNamed:bgrnd];
		whiteBg2.image = [UIImage imageNamed:bgrnd];
		timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setMinuteInTimer) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[self stopPreAlarm];
	[self stopAlarmSound];
		
	[player release];
	[player2 release];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[timer release];
	[timerIco release];
	[alarmIco release];
	[timeAlarmLabel release];
	[timerLabel release];
	[alarmLabel release];
	[alarmOn release];
	[firstHourbg1 release];
	[firstHourbg2 release];
	[firstHourbg3 release];
	[bg1 release];
	[bg2 release];
	[bg3 release];
	[minutesFirst release];
	[minutesSecond release];
	[hoursFirst release];
	[hoursSecond release];
	
//	[isAlarm release];
//	[alarmHour release];
//	[alarmMinute release];
//	[alarmCountDown release];
//	[i release];
//	[steps release];
//	[numbers release];
//	[firstHour release];
//	[firstminutez release];
//	[secondHour release];
//	[isFirstHourFlipEnded release];
//	[isFirstMinuteFlipEnded release];
//	[isSecondHourFlipEnded release];
	[player release];
	[player2 release];
	[secondsLabel release];
	[secondTest release];
	[whiteBg1 release];
	[whiteBg2 release];
	[blackBg1 release];
	[blackBg2 release];
	[myTicker release];
	[hoursFirst release];
	[hoursSecond release];
	[minutesFirst release];
	[minutesSecond release];
    [super dealloc];
}

@end
