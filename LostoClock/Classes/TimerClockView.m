//
//  TimerClockView.m
//  LostoClock
//
//  Created by BUDDAx2 on 26.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimerClockView.h"
#import "LostoClockViewController.h"
#import "TimerSetUp.h"

int timerHour;
int timerMinute;
int timerSecond;

BOOL isAlarm;
//int alarmHour;
//int alarmMinute;

static int inputSeconds;
static int hours;
static int minutes;
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

@implementation TimerClockView

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
		}
		else {
			alarmOn.hidden = YES;
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

- (void)showSeconds{	
	if (secondsLabel.hidden) {
		secondsLabel.hidden = NO;
	}
	else {
		secondsLabel.hidden = YES;
	}
}

- (void) initPl{
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
- (IBAction)goToClock{
	if (isAlarm) {
		[self viewAlarmWindow];
	}
	else {
		[self stopAlarm];
	}
}
- (IBAction)timerShow{
	if (isAlarm) {
		[self viewAlarmWindow];
	}
	else {
		[myTicker invalidate];
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		TimerSetUp * timerView = [[TimerSetUp alloc] initWithNibName:nil bundle:nil];
		[self presentModalViewController:timerView animated:NO];
	}
}
- (void)stopAlarm{
	isAlarm = NO;
	if (player) {
		[player stop];
	}
	if (player2) {
		[player2 stop];
	}
	redColorTurnOn = NO;
	[myTicker invalidate];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	LostoClockViewController * viewController = [[LostoClockViewController alloc] initWithNibName:nil bundle:nil];
	[self presentModalViewController:viewController animated:NO];		
}

-(int)sMinute {
	static NSString *minute;
	NSString *mTime = [NSString stringWithFormat:@"%02d",minutes];
	minute = [mTime substringWithRange:NSMakeRange(1, 1)];
	
	if (redColorTurnOn) {
		return rand() % 9;
	}
	else {
		return [minute integerValue];
	}

	[minute release];
	[mTime release];
}
-(int)fMinute {
	static NSString *minute;
	NSString *mTime = [NSString stringWithFormat:@"%02d",minutes];
	minute = [mTime substringWithRange:NSMakeRange(0, 1)];

	if (redColorTurnOn) {
		return rand() % 9;
	}
	else {
		return [minute integerValue];
	}
	
	[minute release];
	[mTime release];
}

-(int)sHour {
	static NSString *minute;
	NSString *mTime = [NSString stringWithFormat:@"%02d",hours];
	minute = [mTime substringWithRange:NSMakeRange(1, 1)];

	if (redColorTurnOn) {
		return rand() % 9;
	}
	else {
		return [minute integerValue];
	}
	
	[minute release];
	[mTime release];
}
-(int)fHour {
	static NSString *minute;
	NSString *mTime = [NSString stringWithFormat:@"%02d",hours];
	minute = [mTime substringWithRange:NSMakeRange(0, 1)];

	if (redColorTurnOn) {
		return rand() % 9;
	}
	else {
		return [minute integerValue];
	}
	
	[minute release];
	[mTime release];
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
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,numbers];
	bg1.image = [UIImage imageNamed:secMin1];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,prevNumber];
	bg2.image = [UIImage imageNamed:secMin1];
	
	
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
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,prevNumber];
		bg2.image = [UIImage imageNamed:secMin];
		bg2.transform = CGAffineTransformConcat(
												bg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
												CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																				 bg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		[timer invalidate];
		
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,numbers];
		bg3.image = [UIImage imageNamed:secMin3];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,numbers];
		bg2.image = [UIImage imageNamed:secMin2];
		
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
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,firstminutez];
	firstMinutebg1.image = [UIImage imageNamed:secMin1];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,prevNumber];
	firstMinutebg2.image = [UIImage imageNamed:secMin1];	
	
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
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,prevNumber];
		firstMinutebg2.image = [UIImage imageNamed:secMin];
		firstMinutebg2.transform = CGAffineTransformConcat(
														   firstMinutebg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
														   CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																							firstMinutebg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		[timer invalidate];
		
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,firstminutez];
		firstMinutebg3.image = [UIImage imageNamed:secMin3];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,firstminutez];
		firstMinutebg2.image = [UIImage imageNamed:secMin2];
		
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
	
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,secondHour];
	secondHourbg1.image = [UIImage imageNamed:secMin1];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,prevNumber];
	secondHourbg2.image = [UIImage imageNamed:secMin1];	
	
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
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,prevNumber];
		secondHourbg2.image = [UIImage imageNamed:secMin];
		secondHourbg2.transform = CGAffineTransformConcat(
														  secondHourbg2.transform = CGAffineTransformMakeScale(1, (scaleCoef * -1)),
														  CGAffineTransformMakeTranslation(0, (scaleCoef > 0 ? -1 : 1) * 
																						   secondHourbg2.frame.size.height  / 2  + 53));
	}
	
	i++;
	if (i >= steps) {
		i = 0;
		[timer invalidate];
		
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,secondHour];
		secondHourbg3.image = [UIImage imageNamed:secMin3];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,secondHour];
		secondHourbg2.image = [UIImage imageNamed:secMin2];
		
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
	
	NSString *secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,firstHour];
	firstHourbg1.image = [UIImage imageNamed:secMin1];
	
	secMin1 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,prevNumber];
	firstHourbg2.image = [UIImage imageNamed:secMin1];	
	
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
		NSString *secMin = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,prevNumber];
		firstHourbg2.image = [UIImage imageNamed:secMin];
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
		NSString *secMin3 = [NSString stringWithFormat:@"%@-%d-down.png",tableColor,firstHour];
		firstHourbg3.image = [UIImage imageNamed:secMin3];
		
		NSString *secMin2 = [NSString stringWithFormat:@"%@-%d-up.png",tableColor,firstHour];
		firstHourbg2.image = [UIImage imageNamed:secMin2];
		
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
//	
//	[simpleAlert addButtonWithTitle:btn1];
//	[simpleAlert addButtonWithTitle:btn2];
//	[simpleAlert addButtonWithTitle:btn3];
//	
//	//	UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Выбери правильные числа" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:btn1,btn2,btn3,nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == trueChoiceAlarmOff) {
		[self stopAlarm];
	}
	else {
		[self viewAlarmWindow];
	}
}

- (void)showActivity{
	if (blackBg1.hidden) {
		blackBg1.hidden = NO;
	}
	if (blackBg2.hidden) {
		blackBg2.hidden = NO;
	}
	
	timerSecond = timerSecond - 1;
	inputSeconds = timerSecond;
	hours =  inputSeconds / 3600;
	minutes = ( inputSeconds - hours * 3600 ) / 60; 
	
	int secondz = timerSecond - (hours * 3600 + minutes * 60);
	
	if (timerSecond > 0) {
		secondsLabel.text = [NSString stringWithFormat:@"%d",secondz];
	}
	else {
		secondsLabel.hidden = YES;
	}

	
	
	NSLog(@"%d:%d:%d",hours,minutes,secondz);
	
	if (secondz == 59) {
		timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setMinuteInTimer) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

		if (minutes == 0 && hours == 0) {
			isAlarm = YES;
			[self initPl];
			[self playPreAlarm];
		}
	}
	if (secondz == 10 && minutes == 0 && hours == 0) {
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
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	newTime = YES;
	timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setMinuteInTimer) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];	
	
	timerSecond = timerSecond - 1;
	inputSeconds = timerSecond;
	hours =  inputSeconds / 3600;
	minutes = ( inputSeconds - hours * 3600 ) / 60; 
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
